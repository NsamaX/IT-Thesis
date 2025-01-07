import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:logger/logger.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/tag.dart';

class NFCState {
  final TagEntity? lastReadTag;
  final String errorMessage;
  final bool isNFCEnabled;
  final bool isProcessing;
  final bool isWriteOperation;
  final bool isOperationSuccessful;
  final bool isSnackBarDisplayed;

  NFCState({
    this.lastReadTag,
    required this.isNFCEnabled,
    this.errorMessage = '',
    this.isProcessing = false,
    this.isWriteOperation = false,
    this.isOperationSuccessful = false,
    this.isSnackBarDisplayed = false,
  });

  NFCState copyWith({
    TagEntity? lastReadTag,
    String? errorMessage,
    bool? isNFCEnabled,
    bool? isProcessing,
    bool? isWriteOperation,
    bool? isOperationSuccessful,
    bool? isSnackBarDisplayed,
  }) {
    return NFCState(
      lastReadTag: lastReadTag ?? this.lastReadTag,
      errorMessage: errorMessage ?? this.errorMessage,
      isNFCEnabled: isNFCEnabled ?? this.isNFCEnabled,
      isProcessing: isProcessing ?? this.isProcessing,
      isWriteOperation: isWriteOperation ?? this.isWriteOperation,
      isOperationSuccessful: isOperationSuccessful ?? this.isOperationSuccessful,
      isSnackBarDisplayed: isSnackBarDisplayed ?? this.isSnackBarDisplayed,
    );
  }
}

class NFCCubit extends Cubit<NFCState> {
  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: true));
  final List<String> messageBuffer = [];

  NFCCubit() : super(NFCState(isNFCEnabled: false));

  //---------------------------- Logging Utilities ---------------------------//
  void _logAndFlush(String message, {bool isError = false}) {
    messageBuffer.add(message);
    if (messageBuffer.isNotEmpty) {
      final log = messageBuffer.join('\n');
      logger.log(isError ? Level.error : Level.info, log);
      messageBuffer.clear();
    }
  }

  //---------------------------- State Management ----------------------------//
  void emitSafe(NFCState newState) {
    if (!isClosed && newState != state) emit(newState);
  }

  void toggleNFC() {
    emitSafe(state.copyWith(isNFCEnabled: !state.isNFCEnabled));
    _logAndFlush('[State Management] Toggled NFC state to ${state.isNFCEnabled}');
  }

  void resetOperationStatus() => emitSafe(state.copyWith(isOperationSuccessful: false));
  void markSnackBarDisplayed() => emitSafe(state.copyWith(isSnackBarDisplayed: true));
  void resetSnackBarState() => emitSafe(state.copyWith(isSnackBarDisplayed: false));
  void clearErrorMessage() => emitSafe(state.copyWith(errorMessage: ''));

  //----------------------------- Session Control ----------------------------//
  Future<void> startSession({CardEntity? card}) async {
    if (state.isProcessing) return;
    emitSafe(state.copyWith(isProcessing: true));
    _logAndFlush('[Session Control] Starting NFC session: ${card == null ? "Read" : "Write"} mode');
    try {
      if (!await NfcManager.instance.isAvailable()) throw Exception('NFC is not available.');
      await NfcManager.instance.startSession(onDiscovered: (tag) async {
        try {
          if (card == null) {
            await _processRead(tag);
          } else {
            await _processWrite(tag, card);
          }
        } catch (e) {
          emitSafe(state.copyWith(errorMessage: e.toString()));
          _logAndFlush('[Session Control] Error during tag processing: $e', isError: true);
        }
      });
    } catch (e) {
      _logAndFlush('[Session Control] Error initializing NFC session: $e', isError: true);
    } finally {
      emitSafe(state.copyWith(isProcessing: false));
    }
  }

  Future<void> stopSession({String? reason}) async {
    try {
      await NfcManager.instance.stopSession();
      emitSafe(state.copyWith(isNFCEnabled: false));
      _logAndFlush('[Session Control] NFC session stopped. Reason: $reason');
    } catch (e) {
      emitSafe(state.copyWith(errorMessage: 'Error stopping session: $e'));
      _logAndFlush('[Session Control] Error stopping session: $e', isError: true);
    }
  }

  Future<void> restartSessionIfNeeded({CardEntity? card, bool isCardChanged = false}) async {
    if (!state.isProcessing && state.isNFCEnabled) {
      try {
        if (isCardChanged) {
          _logAndFlush('[Error Recovery] Card changed. Restarting NFC session...');
          await stopSession(reason: 'Card changed, restarting session...');
        } else {
          _logAndFlush('[Error Recovery] Restarting NFC session...');
        }
        await startSession(card: card);
      } catch (e) {
        emitSafe(state.copyWith(errorMessage: 'Failed to restart session: ${e.toString()}'));
        _logAndFlush('[Error Recovery] Failed to restart NFC session: ${e.toString()}', isError: true);
      }
    }
  }

  //------------------------------- Processing -------------------------------//
  Future<void> _processRead(NfcTag tag) async {
    final ndef = _validateNDEF(tag);
    final records = _parseNDEFRecords(ndef);
    final tagEntity = _createTagEntity(tag, records);
    emitSafe(state.copyWith(lastReadTag: tagEntity, isOperationSuccessful: true, isWriteOperation: false));
    _logAndFlush('[Processing] Tag read successfully: $tagEntity');
  }

  Future<void> _processWrite(NfcTag tag, CardEntity card) async {
    final ndef = _validateNDEF(tag);
    final message = _createNDEFMessage(card);
    await ndef.write(message);
    emitSafe(state.copyWith(isOperationSuccessful: true, isWriteOperation: true));
    _logAndFlush('[Processing] Tag written successfully for card: ${card.cardId}');
  }

  //--------------------------- Validation Helpers ---------------------------//
  Ndef _validateNDEF(NfcTag tag) {
    final ndef = Ndef.from(tag);
    if (ndef == null) throw Exception('[Validation] Tag does not support NDEF.');
    if (!ndef.isWritable) throw Exception('[Validation] Tag is read-only.');
    return ndef;
  }

  List<String> _parseNDEFRecords(Ndef ndef) {
    final message = ndef.cachedMessage;
    if (message == null || message.records.isEmpty) throw Exception('[Validation] No NDEF message found.');
    return message.records.map((record) => String.fromCharCodes(record.payload).substring(3)).toList();
  }

  TagEntity _createTagEntity(NfcTag tag, List<String> records) {
    final game = records.firstWhere((r) => r.startsWith('game:'), orElse: () => '').split(': ').last;
    final cardId = records.firstWhere((r) => r.startsWith('id:'), orElse: () => '').split(': ').last;
    final tagId = (tag.data['nfca']?['identifier'] as List<dynamic>?)
            ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(':') ?? '';
    if (game.isEmpty || cardId.isEmpty || tagId.isEmpty) throw Exception('[Validation] Incomplete tag data.');
    return TagEntity(tagId: tagId, cardId: cardId, game: game);
  }

  NdefMessage _createNDEFMessage(CardEntity card) {
    final message = NdefMessage([
      NdefRecord.createText('game: ${card.game}'),
      NdefRecord.createText('id: ${card.cardId}'),
    ]);
    if (message.byteLength > 144) throw Exception('[Validation] Data exceeds tag capacity.');
    return message;
  }
}
