import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:logger/logger.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/tag.dart';
import 'package:nfc_project/domain/usecases/tag.dart';

class NFCState {
  final bool isNFCEnabled;
  final bool isProcessing;
  final bool isSnackBarDisplayed;
  final bool isOperationSuccessful;
  final String errorMessage;
  final TagEntity? lastReadTag;
  final List<Map<TagEntity, CardEntity>>? savedTags;

  NFCState({
    required this.isNFCEnabled,
    this.isProcessing = false,
    this.isSnackBarDisplayed = false,
    this.isOperationSuccessful = false,
    this.errorMessage = '',
    this.lastReadTag,
    this.savedTags,
  });

  NFCState copyWith({
    bool? isNFCEnabled,
    bool? isProcessing,
    bool? isSnackBarDisplayed,
    bool? isOperationSuccessful,
    String? errorMessage = '',
    TagEntity? lastReadTag,
    List<Map<TagEntity, CardEntity>>? savedTags,
  }) {
    return NFCState(
      isNFCEnabled: isNFCEnabled ?? this.isNFCEnabled,
      isProcessing: isProcessing ?? this.isProcessing,
      isSnackBarDisplayed: isSnackBarDisplayed ?? this.isSnackBarDisplayed,
      isOperationSuccessful: isOperationSuccessful ?? this.isOperationSuccessful,
      errorMessage: errorMessage ?? this.errorMessage,
      lastReadTag: lastReadTag ?? this.lastReadTag,
      savedTags: savedTags ?? this.savedTags,
    );
  }
}

class NFCCubit extends Cubit<NFCState> {
  final SaveTagUseCase saveTagUseCase;
  final LoadTagsUseCase loadTagsUseCase;

  NFCCubit({
    required this.saveTagUseCase,
    required this.loadTagsUseCase,
  }) : super(NFCState(isNFCEnabled: false, savedTags: []));

  //---------------------------- Utility Function ----------------------------//
  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      printEmojis: true,
    ),
  );
  final List<String> messageBuffer = [];

  void addToBuffer(String message) => messageBuffer.add(message);

  void flushBuffer({bool isError = false}) {
    if (messageBuffer.isNotEmpty) {
      final formattedMessages = messageBuffer.join('\n');
      logger.log(
        isError ? Level.error : Level.info,
        formattedMessages,
      );
      messageBuffer.clear();
    }
  }

  //---------------------------- State Management ----------------------------//
  void emitSafe(NFCState state) {
    if (!isClosed) emit(state);
  }

  void toggleNFC() {
    emitSafe(state.copyWith(isNFCEnabled: !state.isNFCEnabled));
    addToBuffer('[State Change] Toggling NFC state...');
  }

  void resetOperationStatus() => emitSafe(state.copyWith(isOperationSuccessful: false));

  void clearErrorMessage() => emitSafe(state.copyWith(errorMessage: null));

  //---------------------------- SnackBar Control ----------------------------//
  void markSnackBarDisplayed() => emitSafe(state.copyWith(isSnackBarDisplayed: true));

  void resetSnackBarState() => emitSafe(state.copyWith(isSnackBarDisplayed: false));

  //----------------------------- Session Control ----------------------------//
  Future<void> startSession({CardEntity? card}) async {
    try {
      addToBuffer('[NFC Session] Starting ${card == null ? "Read" : "Write"} Session...');
      flushBuffer();
      await _startSession(card == null ? _processRead : (tag) => _processWrite(tag, card));
    } catch (e) {
      addToBuffer('[NFC Session] Error starting session $e');
      flushBuffer(isError: true);
    }
  }

  Future<void> _startSession(Future<void> Function(NfcTag) onDiscovered) async {
    if (state.isProcessing) {
      addToBuffer('[NFC Session] Another NFC process is ongoing.');
      flushBuffer(isError: true);
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
          addToBuffer('[NFC Session] Error during tag processing: $e');
          _handleError(e);
        }
      });
    } catch (e) {
      addToBuffer('[NFC Session] Error during session initialization: $e');
      flushBuffer(isError: true);
    } finally {
      emitSafe(state.copyWith(isProcessing: false));
    }
  }

  Future<void> stopSession({String? reason}) async {
    try {
      addToBuffer('[NFC Session] Stopping session: $reason');
      await NfcManager.instance.stopSession();
      emitSafe(state.copyWith(isNFCEnabled: false));
      addToBuffer('[NFC Session] Session stopped successfully.');
      flushBuffer();
    } catch (e) {
      emitSafe(state.copyWith(errorMessage: 'Error stopping session: $e'));
      addToBuffer('[NFC Session] Error stopping session: $e');
      flushBuffer(isError: true);
    }
  }

  //----------------------------- Error Handling -----------------------------//
  void _handleError(dynamic error) {
    emitSafe(state.copyWith(errorMessage: error.toString()));
    flushBuffer(isError: true);
  }

  //----------------------------- Error Recovery -----------------------------//
  Future<void> restartSessionIfNeeded({CardEntity? card}) async {
    if (!state.isProcessing && !state.isNFCEnabled) {
      try {
        addToBuffer('[Recovery] Restarting NFC session...');
        await startSession(card: card);
      } catch (e) {
        emitSafe(state.copyWith(errorMessage: 'Failed to restart session: $e'));
        addToBuffer('[Recovery] Failed to restart NFC session: $e');
        flushBuffer(isError: true);
      }
    }
  }

  //------------------------------- Processing -------------------------------//
  Future<void> _processRead(NfcTag tag) async {
    final ndef = _validateNDEF(tag);
    final parsedRecords = _parseNDEFRecords(ndef);
    final tagEntity = _createTagEntity(tag, parsedRecords);
    emitSafe(state.copyWith(lastReadTag: tagEntity, isOperationSuccessful: true));
    addToBuffer('[NFC Read] Tag Read Successful: $tagEntity');
    flushBuffer();
  }

  Future<void> _processWrite(NfcTag tag, CardEntity card) async {
    final ndef = _validateNDEF(tag);
    final ndefMessage = _createNDEFMessage(card);
    await _testWrite(ndef);
    await ndef.write(ndefMessage);
    emitSafe(state.copyWith(isOperationSuccessful: true));
    addToBuffer('[NFC Write] NFC Write Successful.');
    flushBuffer();
  }

  //--------------------------- Validation Helpers ---------------------------//
  Ndef _validateNDEF(NfcTag tag) {
    final ndef = Ndef.from(tag);
    if (ndef == null) throw Exception('[NFC Validation] Tag does not support NDEF.');
    if (!ndef.isWritable) throw Exception('[NFC Validation] Tag is read-only.');
    return ndef;
  }

  List<String> _parseNDEFRecords(Ndef ndef) {
    final ndefMessage = ndef.cachedMessage;
    if (ndefMessage == null) throw Exception('[NFC Parsing] No NDEF message found.');
    final records = ndefMessage.records.map((record) {
      try {
        return String.fromCharCodes(record.payload).substring(3);
      } catch (_) {
        throw Exception('[NFC Parsing] Encoding format incompatible.');
      }
    }).toList();
    if (records.isEmpty) throw Exception('[NFC Parsing] No data in NDEF records.');
    return records;
  }

  TagEntity _createTagEntity(NfcTag tag, List<String> parsedRecords) {
    final game = parsedRecords.firstWhere((record) => record.startsWith('game:'), orElse: () => '').split(': ').last;
    final cardId = parsedRecords.firstWhere((record) => record.startsWith('id:'), orElse: () => '').split(': ').last;
    final tagId = _extractTagId(tag);
    if (game.isEmpty || cardId.isEmpty || tagId.isEmpty) throw Exception('[NFC Entity Creation] Incomplete data.');
    return TagEntity(tagId: tagId, cardId: cardId, game: game, timestamp: DateTime.now());
  }

  String _extractTagId(NfcTag tag) {
    return (tag.data['nfca']?['identifier'] as List<dynamic>?)
            ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(':') ?? '';
  }

  NdefMessage _createNDEFMessage(CardEntity card) {
    final message = NdefMessage([
      NdefRecord.createText('game: ${card.game}'),
      NdefRecord.createText('id: ${card.cardId}'),
    ]);
    if (message.byteLength > 144) throw Exception('[NFC Write] Data exceeds tag capacity.');
    return message;
  }

  Future<void> _testWrite(Ndef ndef) async {
    try {
      await ndef.write(NdefMessage([NdefRecord.createText('Test')]));
    } catch (_) {
      throw Exception('[NFC Validation] Tag cannot be written to.');
    }
  }
}
