import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:logger/logger.dart';
import '../../../domain/entities/card.dart';
import '../../../domain/entities/tag.dart';
import '../../../domain/usecases/tag.dart';

class NFCState {
  final bool isNFCEnabled;
  final TagEntity? lastReadTag;
  final String? errorMessage;
  final bool isOperationSuccessful;
  final List<Map<TagEntity, CardEntity>>? savedTags;

  NFCState({
    required this.isNFCEnabled,
    this.lastReadTag,
    this.errorMessage,
    this.isOperationSuccessful = false,
    this.savedTags,
  });

  NFCState copyWith({
    bool? isNFCEnabled,
    TagEntity? lastReadTag,
    String? errorMessage,
    bool? isOperationSuccessful,
    List<Map<TagEntity, CardEntity>>? savedTags,
  }) {
    return NFCState(
      isNFCEnabled: isNFCEnabled ?? this.isNFCEnabled,
      lastReadTag: lastReadTag ?? this.lastReadTag,
      errorMessage: errorMessage ?? this.errorMessage,
      isOperationSuccessful:
          isOperationSuccessful ?? this.isOperationSuccessful,
      savedTags: savedTags ?? this.savedTags,
    );
  }
}

class NFCCubit extends Cubit<NFCState> {
  final SaveTagUseCase saveTagUseCase;
  final LoadTagsUseCase loadTagsUseCase;
  final Logger logger = Logger();
  bool _isProcessing = false;

  static const String nfcUnavailableMessage =
      'NFC is not available on this device.';
  static const String tagNotWritableMessage =
      'The detected tag is not writable. Please try another tag.';
  static const String tagTooLargeMessage =
      'The data exceeds the tag\'s capacity. Please reduce the size of the data.';

  NFCCubit({
    required this.saveTagUseCase,
    required this.loadTagsUseCase,
  }) : super(NFCState(isNFCEnabled: false, savedTags: []));

  @override
  Future<void> close() async {
    logger.i('NFCCubit is being closed.');
    return super.close();
  }

  void emitSafe(NFCState state) {
    if (!isClosed) emit(state);
  }

  void toggleNFC() {
    emitSafe(state.copyWith(isNFCEnabled: !state.isNFCEnabled));
    logger.i('NFC toggled: ${state.isNFCEnabled ? "Enabled" : "Disabled"}');
  }

  void resetOperationStatus() {
    emitSafe(state.copyWith(isOperationSuccessful: false));
  }

  void clearErrorMessage() {
    emitSafe(state.copyWith(errorMessage: null));
  }

  Future<void> start({CardEntity? card}) async {
    logger.i(card == null
        ? 'Start NFC Read Process...'
        : 'Start NFC Write Process...');
    if (card == null) {
      await _startSession(_processRead);
    } else {
      await _startSession((tag) => _processWrite(tag, card));
    }
  }

  Future<void> _startSession(
      Future<void> Function(NfcTag tag) onDiscovered) async {
    if (_isProcessing) {
      logger.w('Another NFC process is ongoing.');
      return;
    }
    _isProcessing = true;
    try {
      if (!await NfcManager.instance.isAvailable()) {
        throw Exception(nfcUnavailableMessage);
      }
      NfcManager.instance.startSession(onDiscovered: (tag) async {
        try {
          await onDiscovered(tag);
        } catch (e) {
          logger.e('Error processing NFC tag: $e');
          emitSafe(state.copyWith(errorMessage: e.toString()));
        } finally {
          _isProcessing = false;
        }
      });
    } catch (e) {
      logger.e('Error initializing NFC session: $e');
      emitSafe(state.copyWith(errorMessage: e.toString()));
      _isProcessing = false;
    }
  }

  Future<void> stopSession({String? reason}) async {
    try {
      logger.i('Stopping NFC session: $reason');
      await NfcManager.instance.stopSession();
      emit(state.copyWith(isNFCEnabled: false));
      logger.i('NFC session stopped successfully.');
    } catch (e) {
      logger.e('Error stopping NFC session: $e');
      emit(state.copyWith(errorMessage: 'Error stopping NFC session: $e'));
    }
  }

  Future<void> _processRead(NfcTag tag) async {
    logger.i('Tag discovered: ${tag.data}');
    final ndef = Ndef.from(tag);
    if (ndef == null) throw Exception('This tag does not support NDEF.');

    final tagId = _extractTagId(tag);
    final gameAndCardId = _parseGameAndCardId(tag.data);
    final tagEntity = TagEntity(
      tagId: tagId,
      cardId: gameAndCardId['cardId'] ?? '',
      game: gameAndCardId['game'] ?? '',
      timestamp: DateTime.now(),
    );

    logger.i('Tag Read Successful: $tagEntity');
    emitSafe(
        state.copyWith(lastReadTag: tagEntity, isOperationSuccessful: true));
  }

  Future<void> _processWrite(NfcTag tag, CardEntity card) async {
    logger.i('Tag discovered for writing: ${tag.data}');
    final ndef = Ndef.from(tag);
    if (ndef == null) throw Exception('This tag does not support NDEF.');
    if (!ndef.isWritable) throw Exception('This tag is read-only.');

    final ndefMessage = NdefMessage([
      NdefRecord.createText('Card Name: ${card.name}'),
      NdefRecord.createText('Game: ${card.game}'),
      NdefRecord.createText('Card ID: ${card.cardId}'),
    ]);

    if (ndefMessage.byteLength > ndef.maxSize)
      throw Exception('Data exceeds tag capacity.');

    await ndef.write(ndefMessage);
    logger.i('NFC Write Successful.');

    final tagId = _extractTagId(tag);
    final tagEntity = TagEntity(
      tagId: tagId,
      cardId: card.cardId,
      game: card.game,
      timestamp: DateTime.now(),
    );

    await _saveTagWithCard(tagEntity, card);
    emitSafe(state.copyWith(isOperationSuccessful: true));
  }

  String _extractTagId(NfcTag tag) {
    final tagId = (tag.data['nfca']?['identifier'] as List<dynamic>?)
        ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join(':');
    if (tagId == null) throw Exception('Unable to read tag ID.');
    return tagId;
  }

  Map<String, String?> _parseGameAndCardId(Map<String, dynamic> data) {
    final cachedMessage = data['ndef']?['cachedMessage'];
    String? game;
    String? cardId;

    if (cachedMessage != null && cachedMessage['records'] != null) {
      for (var record in (cachedMessage['records'] as List<dynamic>)) {
        final payload = record['payload'] as List<dynamic>?;
        if (payload != null) {
          final text = String.fromCharCodes(payload.cast<int>().sublist(3));
          if (text.startsWith('Game:')) {
            game = text.replaceFirst('Game: ', '').trim();
          } else if (text.startsWith('Card ID:')) {
            cardId = text.replaceFirst('Card ID: ', '').trim();
          }
        }
      }
    }

    return {'game': game, 'cardId': cardId};
  }

  Future<void> _saveTagWithCard(
      TagEntity tagEntity, CardEntity cardEntity) async {
    try {
      await saveTagUseCase(tagEntity, cardEntity);
      logger.i('Tag and Card saved successfully.');
      await loadTags();
    } catch (e) {
      logger.e('Error saving tag and card: $e');
      emitSafe(state.copyWith(errorMessage: 'Error saving tag and card: $e'));
    }
  }

  Future<void> loadTags() async {
    try {
      final tagsWithCards = await loadTagsUseCase();
      emitSafe(state.copyWith(savedTags: tagsWithCards));
      logger.i('Tags and Cards loaded successfully.');
    } catch (e) {
      logger.e('Error loading tags and cards: $e');
      emitSafe(
          state.copyWith(errorMessage: 'Error loading tags and cards: $e'));
    }
  }
}
