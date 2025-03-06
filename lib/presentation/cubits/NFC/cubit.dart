import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/tag.dart';

part 'helper.dart';
part 'state.dart';

class NFCCubit extends Cubit<NFCState> {
  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: true));
  final List<String> messageBuffer = [];

  NFCCubit() : super(NFCState(isNFCEnabled: false));

  void emitSafe(NFCState newState) {
    if (!isClosed && newState != state) {
      emit(newState);
    }
  }

  void markSnackBarDisplayed() => emitSafe(state.copyWith(isSnackBarDisplayed: true));

  void resetSnackBarState() => emitSafe(state.copyWith(isSnackBarDisplayed: false));

  void resetOperationStatus() => emitSafe(state.copyWith(isOperationSuccessful: false));

  void clearErrorMessage() => emitSafe(state.copyWith(errorMessage: ''));

  void _addMessage(String message) => messageBuffer.add(message);

  void _flushMessages({bool isError = false}) {
    if (messageBuffer.isNotEmpty) {
      final log = messageBuffer.join('\n');
      logger.log(isError ? Level.error : Level.info, log);
      messageBuffer.clear();
    }
  }

  void toggleNFC() {
    emitSafe(state.copyWith(isNFCEnabled: !state.isNFCEnabled));
    _addMessage('[State Management] Toggled NFC state to ${state.isNFCEnabled}');
  }

  Future<void> startSession({CardEntity? card}) async {
    if (state.isProcessing) return;
    emitSafe(state.copyWith(isProcessing: true));

    _addMessage('[Session Control] Starting NFC session: ${card == null ? "Read" : "Write"} mode');
    _flushMessages();

    try {
      if (!await NfcManager.instance.isAvailable()) {
        throw Exception('NFC is not available.');
      }

      await NfcManager.instance.startSession(onDiscovered: (tag) async {
        try {
          if (card == null) {
            await _processRead(tag);
          } else {
            await _processWrite(tag, card);
          }
        } catch (e) {
          emitSafe(state.copyWith(errorMessage: e.toString()));
          _addMessage('[Session Control] Error during tag processing: $e');
          _flushMessages(isError: true);
        }
      });
    } catch (e) {
      emitSafe(state.copyWith(errorMessage: 'NFC session failed: $e'));
      _addMessage('[Session Control] Error initializing NFC session: $e');
      _flushMessages(isError: true);
    } finally {
      emitSafe(state.copyWith(isProcessing: false));
    }
  }

  Future<void> stopSession({String? reason}) async {
    try {
      await NfcManager.instance.stopSession();
      emitSafe(state.copyWith(isNFCEnabled: false));
      _addMessage('[Session Control] NFC session stopped. Reason: $reason');
      _flushMessages();
    } catch (e) {
      emitSafe(state.copyWith(errorMessage: 'Error stopping session: $e'));
      _addMessage('[Session Control] Error stopping session: $e');
      _flushMessages(isError: true);
    }
  }

  Future<void> restartSessionIfNeeded({CardEntity? card, bool isCardChanged = false}) async {
    if (!state.isProcessing && state.isNFCEnabled) {
      try {
        if (isCardChanged) {
          _addMessage('[Error Recovery] Card changed. Restarting NFC session...');
          await stopSession(reason: 'Card changed, restarting session...');
        }
        await startSession(card: card);
      } catch (e) {
        emitSafe(state.copyWith(errorMessage: 'Failed to restart session: ${e.toString()}'));
        _addMessage('[Error Recovery] Failed to restart NFC session: ${e.toString()}');
        _flushMessages(isError: true);
      }
    }
  }

  Future<void> _processRead(NfcTag tag) async {
    try {
      final ndef = validateNDEF(tag);
      final records = parseNDEFRecords(ndef);
      final tagEntity = createTagEntity(tag, records);

      emitSafe(state.copyWith(
        lastestReadTags: tagEntity,
        isOperationSuccessful: true,
        isWriteOperation: false,
      ));

      _addMessage('[Processing] Tag read successfully for card id[${tagEntity.cardId}]');
      _flushMessages();
    } catch (e) {
      emitSafe(state.copyWith(errorMessage: 'Error reading tag: $e'));
      _addMessage('[Processing] Error reading tag: $e');
      _flushMessages(isError: true);
    }
  }

  Future<void> _processWrite(NfcTag tag, CardEntity card) async {
    try {
      final ndef = validateNDEF(tag);
      final message = createNDEFMessage(card);
      await ndef.write(message);

      emitSafe(state.copyWith(
        errorMessage: '',
        isOperationSuccessful: true,
        isWriteOperation: true,
      ));

      _addMessage('[Processing] Tag written successfully for card id[${card.cardId}]');
      _flushMessages();
    } catch (e) {
      emitSafe(state.copyWith(errorMessage: 'Error writing to tag: $e'));
      _addMessage('[Processing] Error writing to tag: $e');
      _flushMessages(isError: true);
    }
  }
}
