import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:logger/logger.dart';

import 'package:nfc_project/core/utils/exceptions.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/tag.dart';
import 'package:nfc_project/domain/usecases/tag.dart';

class NFCState {
  final bool isNFCEnabled;
  final bool isProcessing;
  final TagEntity? lastReadTag;
  final String? errorMessage;
  final bool isOperationSuccessful;
  final List<Map<TagEntity, CardEntity>>? savedTags;

  NFCState({
    required this.isNFCEnabled,
    this.isProcessing = false,
    this.lastReadTag,
    this.errorMessage,
    this.isOperationSuccessful = false,
    this.savedTags,
  });

  NFCState copyWith({
    bool? isNFCEnabled,
    bool? isProcessing,
    TagEntity? lastReadTag,
    String? errorMessage,
    bool? isOperationSuccessful,
    List<Map<TagEntity, CardEntity>>? savedTags,
  }) {
    return NFCState(
      isNFCEnabled: isNFCEnabled ?? this.isNFCEnabled,
      isProcessing: isProcessing ?? this.isProcessing,
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

  void handleError(Exception e, [String? customMessage]) {
    final message = customMessage ?? e.toString();
    logger.e("Error Occurred: $message");
    _isProcessing = false;
    emitSafe(state.copyWith(
      errorMessage: message,
      isOperationSuccessful: false,
    ));
  }

  void logAndEmitError(String logMessage, String errorMessage) {
    logger.e(logMessage);
    emitSafe(state.copyWith(errorMessage: errorMessage));
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
    clearErrorMessage();

    logger.i(card == null
        ? 'Start NFC Read Process...'
        : 'Start NFC Write Process...');

    if (state.isProcessing) {
      logAndEmitError(
          'Another NFC process is ongoing.', 'NFC is already in use.');
      return;
    }

    emitSafe(state.copyWith(isProcessing: true));

    try {
      if (card == null) {
        await _startSession(_processRead);
      } else {
        await _startSession((tag) => _processWrite(tag, card));
      }
    } catch (e) {
      handleError(e as Exception, 'Error initializing NFC session.');
    } finally {
      emitSafe(state.copyWith(isProcessing: false));
    }
  }

  Future<void> _startSession(
      Future<void> Function(NfcTag tag) onDiscovered) async {
    if (_isProcessing) {
      logAndEmitError(
          'Another NFC process is ongoing.', 'NFC is already in use.');
      return;
    }
    _isProcessing = true;
    try {
      if (!await NfcManager.instance.isAvailable()) {
        throw NFCUnavailableException();
      }

      await Future.any([
        NfcManager.instance.startSession(onDiscovered: (tag) async {
          try {
            await onDiscovered(tag);
          } catch (e) {
            handleError(e as Exception, 'Error processing NFC tag.');
          }
        }),
        Future.delayed(Duration(seconds: 30), () {
          throw NFCTimeoutException("NFC session timed out.");
        }),
      ]);
    } catch (e) {
      handleError(e as Exception, 'Error initializing NFC session.');
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> stopSession({String? reason}) async {
    try {
      logger.i('Stopping NFC session: $reason');
      await NfcManager.instance.stopSession();
      emitSafe(state.copyWith(isNFCEnabled: false));
      logger.i('NFC session stopped successfully.');
    } catch (e) {
      handleError(e as Exception, 'Error stopping NFC session.');
    }
  }

  Future<void> _processRead(NfcTag tag) async {
    try {
      logger.i('Tag discovered: ${tag.data}');
      final ndef = Ndef.from(tag);
      if (ndef == null) {
        throw NFCReadException("This tag does not support NDEF.");
      }
      final tagId = _extractTagId(tag);
      final gameAndCardId = _parseGameAndCardId(tag.data);
      final tagEntity = TagEntity(
        tagId: tagId,
        cardId: gameAndCardId['cardId'] ?? '',
        game: gameAndCardId['game'] ?? '',
        timestamp: DateTime.now(),
      );

      logger.i('Tag Read Successful: $tagEntity');
      emitSafe(state.copyWith(
        lastReadTag: tagEntity,
        isOperationSuccessful: true,
      ));
    } catch (e) {
      handleError(e as Exception, 'Error reading NFC tag.');
    }
  }

  Future<void> _processWrite(NfcTag tag, CardEntity card) async {
    try {
      logger.i('Tag discovered for writing: ${tag.data}');

      final ndef = Ndef.from(tag);
      if (ndef == null) {
        throw NFCWriteException("This tag does not support NDEF.");
      }
      if (!ndef.isWritable) {
        throw NFCWriteException("This tag is read-only.");
      }

      final ndefMessage = NdefMessage([
        NdefRecord.createText('Card Name: ${card.name}'),
        NdefRecord.createText('Game: ${card.game}'),
        NdefRecord.createText('Card ID: ${card.cardId}'),
      ]);

      if (ndefMessage.byteLength > ndef.maxSize) {
        throw NFCTagCapacityException();
      }

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
    } catch (e) {
      final errorMessage =
          e is NFCWriteException || e is NFCTagCapacityException
              ? e.toString()
              : "An unexpected error occurred while writing to the NFC tag.";
      logger.e('Error writing NFC tag: $errorMessage');

      emitSafe(state.copyWith(
        errorMessage: errorMessage,
        isProcessing: false,
        isOperationSuccessful: false,
      ));
    } finally {
      _isProcessing = false;
      emitSafe(state.copyWith(isProcessing: false));
    }
  }

  String _extractTagId(NfcTag tag) {
    final tagId = (tag.data['nfca']?['identifier'] as List<dynamic>?)
        ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join(':');
    if (tagId == null) {
      throw NFCReadException('Unable to extract tag ID from the tag.');
    }
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

    if (game == null || cardId == null) {
      throw NFCReadException('Unable to parse game or card ID from the tag.');
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
      handleError(e as Exception, 'Error saving tag and card.');
    }
  }

  Future<void> loadTags() async {
    try {
      final tagsWithCards = await loadTagsUseCase();
      emitSafe(state.copyWith(savedTags: tagsWithCards));
      logger.i('Tags and Cards loaded successfully.');
    } catch (e) {
      handleError(e as Exception, 'Error loading tags and cards.');
    }
  }
}
