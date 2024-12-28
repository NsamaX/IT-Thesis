import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:logger/logger.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/tag.dart';
import 'package:nfc_project/domain/usecases/tag.dart';

class NFCState {
  final bool isNFCEnabled;
  final bool isProcessing;
  final bool isOperationSuccessful;
  final String? errorMessage;
  final TagEntity? lastReadTag;
  final List<Map<TagEntity, CardEntity>>? savedTags;

  NFCState({
    required this.isNFCEnabled,
    this.isProcessing = false,
    this.isOperationSuccessful = false,
    this.errorMessage,
    this.lastReadTag,
    this.savedTags,
  });

  NFCState copyWith({
    bool? isNFCEnabled,
    bool? isProcessing,
    bool? isOperationSuccessful,
    String? errorMessage,
    TagEntity? lastReadTag,
    List<Map<TagEntity, CardEntity>>? savedTags,
  }) {
    return NFCState(
      isNFCEnabled: isNFCEnabled ?? this.isNFCEnabled,
      isProcessing: isProcessing ?? this.isProcessing,
      isOperationSuccessful: isOperationSuccessful ?? this.isOperationSuccessful,
      errorMessage: errorMessage ?? this.errorMessage,
      lastReadTag: lastReadTag ?? this.lastReadTag,
      savedTags: savedTags ?? this.savedTags,
    );
  }
}

class NFCCubit extends Cubit<NFCState> {
  final Logger logger = Logger();

  final SaveTagUseCase saveTagUseCase;
  final LoadTagsUseCase loadTagsUseCase;

  static const String nfcUnavailableMessage = 'NFC is not available on this device.';
  static const String tagNotWritableMessage = 'The detected tag is not writable. Please try another tag.';
  static const String tagTooLargeMessage = 'The data exceeds the tag\'s capacity. Please reduce the size of the data.';

  NFCCubit({
    required this.saveTagUseCase,
    required this.loadTagsUseCase,
  }) : super(NFCState(isNFCEnabled: false, savedTags: []));

  //----------------------------- State Control ------------------------------//

  @override
  Future<void> close() async {
    return super.close();
  }

  void emitSafe(NFCState state) {
    if (!isClosed) emit(state);
  }

  void toggleNFC() {
    emitSafe(state.copyWith(isNFCEnabled: !state.isNFCEnabled));
  }

  void resetOperationStatus() {
    emitSafe(state.copyWith(isOperationSuccessful: false));
  }

  void clearErrorMessage() {
    emitSafe(state.copyWith(errorMessage: null));
  }

  //---------------------------- Session Control -----------------------------//

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

  Future<void> _startSession(Future<void> Function(NfcTag tag) onDiscovered) async {
    if (state.isProcessing) {
      logger.w('Another NFC process is ongoing.');
      return;
    }
    emitSafe(state.copyWith(isProcessing: true));
    try {
      if (!await NfcManager.instance.isAvailable()) {
        throw Exception('NFC is not available on this device.');
      }
      NfcManager.instance.startSession(onDiscovered: (tag) async {
        try {
          await onDiscovered(tag);
        } catch (e) {
          logger.e('Error processing NFC tag: $e');
          emitSafe(state.copyWith(errorMessage: e.toString()));
        } finally {
          emitSafe(state.copyWith(isProcessing: false));
        }
      });
    } catch (e) {
      logger.e('Error initializing NFC session: $e');
      emitSafe(state.copyWith(errorMessage: e.toString()));
    } finally {
      emitSafe(state.copyWith(isProcessing: false));
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

  //------------------------------ Read Session ------------------------------//

  Future<void> _processRead(NfcTag tag) async {
    logger.i('Tag discovered: ${tag.data}');
    final ndef = Ndef.from(tag);
    if (ndef == null) {
      throw Exception('This NFC tag is not supported. Please use a compatible tag.');
    }
    final ndefMessage = tag.data['ndef']?['cachedMessage'];
    if (ndefMessage == null) {
      throw Exception('No NDEF message found on the tag.');
    }
    final records = ndefMessage['records'] as List<dynamic>;
    final parsedRecords = records.map((record) {
      final payload = record['payload'] as List<int>;
      return String.fromCharCodes(payload).substring(3);
    }).toList();
    logger.i('Parsed Records: $parsedRecords');
    final cardIdMatch = parsedRecords
        .firstWhere((record) => record.startsWith('Card ID:'), orElse: () => '')
        .split(': ')
        .last;
    final gameMatch = parsedRecords
        .firstWhere((record) => record.startsWith('Game:'), orElse: () => '')
        .split(': ')
        .last;
    final tagId = _extractTagId(tag);
    final tagEntity = TagEntity(
      tagId: tagId,
      cardId: cardIdMatch,
      game: gameMatch,
      timestamp: DateTime.now(),
    );
    logger.i('Tag Read Successful: $tagEntity');
    emitSafe(state.copyWith(lastReadTag: tagEntity, isOperationSuccessful: true),
    );
  }

  //------------------------------ Write Session -----------------------------//

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
    for (var record in ndefMessage.records) {
      logger.i('Writing record: ${String.fromCharCodes(record.payload)}');
    }
    await ndef.write(ndefMessage);
    logger.i('NFC Write Successful.');
    emitSafe(state.copyWith(isProcessing: false, isOperationSuccessful: true));
    await stopSession(reason: 'Tag written successfully');
  }

  String _extractTagId(NfcTag tag) {
    final tagId = (tag.data['nfca']?['identifier'] as List<dynamic>?)
        ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join(':');
    if (tagId == null) throw Exception('Unable to read tag ID.');
    return tagId;
  }

  //------------------------------- Tag Session ------------------------------//

  Future<void> scanHistory(TagEntity tagEntity, CardEntity cardEntity) async {
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
    } catch (e) {
      emitSafe(state.copyWith(errorMessage: 'Error loading tags and cards: $e'));
    }
  }
}
