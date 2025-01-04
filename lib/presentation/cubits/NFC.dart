import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:logger/logger.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/tag.dart';

class NFCState {
  final bool isNFCEnabled, isProcessing, isWriteOperation, isOperationSuccessful, isSnackBarDisplayed;
  final String errorMessage;
  final TagEntity? lastReadTag;

  NFCState({
    required this.isNFCEnabled,
    this.isProcessing = false,
    this.isWriteOperation = false,
    this.isOperationSuccessful = false,
    this.isSnackBarDisplayed = false,
    this.errorMessage = '',
    this.lastReadTag,
  });

  NFCState copyWith({
    bool? isNFCEnabled, isProcessing, isWriteOperation, isOperationSuccessful, isSnackBarDisplayed,
    String? errorMessage,
    TagEntity? lastReadTag,
  }) {
    return NFCState(
      isNFCEnabled: isNFCEnabled ?? this.isNFCEnabled,
      isProcessing: isProcessing ?? this.isProcessing,
      isWriteOperation: isWriteOperation ?? this.isWriteOperation,
      isSnackBarDisplayed: isSnackBarDisplayed ?? this.isSnackBarDisplayed,
      isOperationSuccessful: isOperationSuccessful ?? this.isOperationSuccessful,
      errorMessage: errorMessage ?? this.errorMessage,
      lastReadTag: lastReadTag ?? this.lastReadTag,
    );
  }
}

class NFCCubit extends Cubit<NFCState> {
  NFCCubit() : super(NFCState(isNFCEnabled: false));

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
      logger.log(isError ? Level.error : Level.info, formattedMessages);
      messageBuffer.clear();
    }
  }

  //---------------------------- State Management ----------------------------//
  void emitSafe(NFCState state) {
    if (!isClosed && state != this.state) emit(state);
  }

  void toggleNFC() {
    emitSafe(state.copyWith(isNFCEnabled: !state.isNFCEnabled));
    addToBuffer('[State Management] Toggling NFC state from ${state.isNFCEnabled} to ${!state.isNFCEnabled}');
  }

  void resetOperationStatus() {
    emitSafe(state.copyWith(isOperationSuccessful: false));
    addToBuffer('[State Management] Resetting operation status');
  }

  void markSnackBarDisplayed() {
    emitSafe(state.copyWith(isSnackBarDisplayed: true));
    addToBuffer('[State Management] Marking snackbar as displayed');
  }

  void resetSnackBarState() {
    emitSafe(state.copyWith(isSnackBarDisplayed: false));
    addToBuffer('[State Management] Resetting snackbar state');
  }

  void clearErrorMessage() {
    emitSafe(state.copyWith(errorMessage: ''));
    addToBuffer('[State Management] Clearing error message');
  }

  //----------------------------- Session Control ----------------------------//
  Future<void> startSession({CardEntity? card}) async {
    try {
      addToBuffer('[Session Control] Starting NFC session: ${card == null ? "Read" : "Write"} mode');
      flushBuffer();
      await _startSession(card == null ? _processRead : (tag) => _processWrite(tag, card));
    } catch (e) {
      addToBuffer('[Session Control] Error starting NFC session: ${e.toString()}');
      flushBuffer(isError: true);
    }
  }

  Future<void> _startSession(Future<void> Function(NfcTag) onDiscovered) async {
    if (state.isProcessing) {
      addToBuffer('[Session Control] NFC session already in progress');
      flushBuffer(isError: true);
      return;
    }
    emitSafe(state.copyWith(isProcessing: true));
    try {
      if (!await NfcManager.instance.isAvailable()) {
        addToBuffer('[Session Control] NFC not available on this device');
        throw Exception('NFC is not available.');
      }
      NfcManager.instance.startSession(onDiscovered: (tag) async {
        addToBuffer('[Session Control] Tag discovered');
        try {
          await onDiscovered(tag);
        } catch (e) {
          emitSafe(state.copyWith(errorMessage: e.toString()));
          addToBuffer('[Session Control] Error during tag processing: ${e.toString()}');
          flushBuffer(isError: true);
        }
      });
    } catch (e) {
      addToBuffer('[Session Control] Error initializing NFC session: ${e.toString()}');
      flushBuffer(isError: true);
    } finally {
      emitSafe(state.copyWith(isProcessing: false));
    }
  }

  Future<void> stopSession({String? reason}) async {
    try {
      addToBuffer('[Session Control] Stopping NFC session. Reason: $reason');
      await NfcManager.instance.stopSession();
      emitSafe(state.copyWith(isNFCEnabled: false));
      addToBuffer('[Session Control] NFC session stopped successfully');
      flushBuffer();
    } catch (e) {
      emitSafe(state.copyWith(errorMessage: 'Error stopping session: ${e.toString()}'));
      addToBuffer('[Session Control] Error stopping NFC session: ${e.toString()}');
      flushBuffer(isError: true);
    }
  }

  //----------------------------- Error Recovery -----------------------------//
  Future<void> restartSessionIfNeeded({CardEntity? card, bool isCardChanged = false}) async {
    if (!state.isProcessing && state.isNFCEnabled) {
      try {
        if (isCardChanged) {
          addToBuffer('[Error Recovery] Card changed. Restarting NFC session...');
          await stopSession(reason: 'Card changed, restarting session...');
        } else {
          addToBuffer('[Error Recovery] Restarting NFC session...');
        }
        await startSession(card: card);
      } catch (e) {
        emitSafe(state.copyWith(errorMessage: 'Failed to restart session: ${e.toString()}'));
        addToBuffer('[Error Recovery] Failed to restart NFC session: ${e.toString()}');
        flushBuffer(isError: true);
      }
    }
  }

  //------------------------------- Processing -------------------------------//
  Future<void> _processRead(NfcTag tag) async {
    addToBuffer('[Processing] Read operation');
    final ndef = _validateNDEF(tag);
    final parsedRecords = _parseNDEFRecords(ndef);
    final tagEntity = _createTagEntity(tag, parsedRecords);
    emitSafe(state.copyWith(
      lastReadTag: tagEntity,
      isOperationSuccessful: true,
      isWriteOperation: false,
    ));
    addToBuffer('[Processing] Tag read successfully: $tagEntity');
    flushBuffer();
  }

  Future<void> _processWrite(NfcTag tag, CardEntity card) async {
    addToBuffer('[Processing] Write operation');
    final ndef = _validateNDEF(tag);
    final ndefMessage = _createNDEFMessage(card);
    await _testWrite(ndef);
    await ndef.write(ndefMessage);
    emitSafe(state.copyWith(
      isOperationSuccessful: true,
      isWriteOperation: true,
    ));
    addToBuffer('[Processing] Tag written successfully');
    flushBuffer();
  }

  //--------------------------- Validation Helpers ---------------------------//
  Ndef _validateNDEF(NfcTag tag) {
    addToBuffer('[Validation] Validating NDEF tag');
    final ndef = Ndef.from(tag);
    if (ndef == null) {
      addToBuffer('[Validation] Validation failed: Tag does not support NDEF');
      throw Exception('[NFC Validation] Tag does not support NDEF.');
    }
    if (!ndef.isWritable) {
      addToBuffer('[Validation] Validation failed: Tag is read-only');
      throw Exception('[NFC Validation] Tag is read-only.');
    }
    return ndef;
  }

  List<String> _parseNDEFRecords(Ndef ndef) {
    addToBuffer('[Validation] Parsing NDEF records');
    final ndefMessage = ndef.cachedMessage;
    if (ndefMessage == null) {
      addToBuffer('[Validation] Parsing failed: No NDEF message found');
      throw Exception('[NFC Parsing] No NDEF message found.');
    }
    final records = ndefMessage.records.map((record) {
      try {
        return String.fromCharCodes(record.payload).substring(3);
      } catch (_) {
        addToBuffer('[Validation] Parsing failed: Encoding format incompatible');
        throw Exception('[NFC Parsing] Encoding format incompatible. Record: ${record.payload}');
      }
    }).toList();
    if (records.isEmpty) {
      addToBuffer('[Validation] Parsing failed: No data in NDEF records');
      throw Exception('[NFC Parsing] No data in NDEF records.');
    }
    return records;
  }

  TagEntity _createTagEntity(NfcTag tag, List<String> parsedRecords) {
    addToBuffer('[Validation] Creating TagEntity from records');
    final game = parsedRecords.firstWhere((record) => record.startsWith('game:'), orElse: () => '').split(': ').last;
    final cardId = parsedRecords.firstWhere((record) => record.startsWith('id:'), orElse: () => '').split(': ').last;
    final tagId = _extractTagId(tag);
    if (game.isEmpty || cardId.isEmpty || tagId.isEmpty) {
      addToBuffer('[Validation] Creation failed: Incomplete data');
      throw Exception('[NFC Entity Creation] Incomplete data.');
    }
    return TagEntity(tagId: tagId, cardId: cardId, game: game, timestamp: DateTime.now());
  }

  String _extractTagId(NfcTag tag) {
    addToBuffer('[Validation] Extracting tag ID');
    return (tag.data['nfca']?['identifier'] as List<dynamic>?)
            ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(':') ?? '';
  }

  NdefMessage _createNDEFMessage(CardEntity card) {
    addToBuffer('[Validation] Creating NDEF message for card id: ${card.cardId}');
    final message = NdefMessage([
      NdefRecord.createText('game: ${card.game}'),
      NdefRecord.createText('id: ${card.cardId}'),
    ]);
    if (message.byteLength > 144) {
      addToBuffer('[Validation] Creation failed: Data exceeds tag capacity');
      throw Exception('[NFC Write] Data exceeds tag capacity.');
    }
    return message;
  }

  Future<void> _testWrite(Ndef ndef) async {
    addToBuffer('[Validation] Testing write capability');
    try {
      await ndef.write(NdefMessage([NdefRecord.createText('Test')]));
    } catch (_) {
      addToBuffer('[Validation] Test write failed: Tag cannot be written to');
      throw Exception('[NFC Validation] Tag cannot be written to.');
    }
  }
}
