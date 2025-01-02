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
  final bool isOperationSuccessful;
  final String errorMessage;
  final bool isSnackBarDisplayed;
  final TagEntity? lastReadTag;
  final List<Map<TagEntity, CardEntity>>? savedTags;

  NFCState({
    required this.isNFCEnabled,
    this.isProcessing = false,
    this.isOperationSuccessful = false,
    this.errorMessage = '',
    this.isSnackBarDisplayed = false,
    this.lastReadTag,
    this.savedTags,
  });

  NFCState copyWith({
    bool? isNFCEnabled,
    bool? isProcessing,
    bool? isOperationSuccessful,
    String? errorMessage = '',
    bool? isSnackBarDisplayed,
    TagEntity? lastReadTag,
    List<Map<TagEntity, CardEntity>>? savedTags,
  }) {
    return NFCState(
      isNFCEnabled: isNFCEnabled ?? this.isNFCEnabled,
      isProcessing: isProcessing ?? this.isProcessing,
      isOperationSuccessful: isOperationSuccessful ?? this.isOperationSuccessful,
      errorMessage: errorMessage ?? this.errorMessage,
      isSnackBarDisplayed: isSnackBarDisplayed ?? this.isSnackBarDisplayed,
      lastReadTag: lastReadTag ?? this.lastReadTag,
      savedTags: savedTags ?? this.savedTags,
    );
  }
}

class NFCCubit extends Cubit<NFCState> {
  final Logger logger = Logger();
  final SaveTagUseCase saveTagUseCase;
  final LoadTagsUseCase loadTagsUseCase;

  // Constructor
  NFCCubit({
    required this.saveTagUseCase,
    required this.loadTagsUseCase,
  }) : super(NFCState(isNFCEnabled: false, savedTags: []));

  //---------------------------- State Management ----------------------------//
  /// Emits a new state safely if the cubit is not closed.
  void emitSafe(NFCState state) {
    if (!isClosed) emit(state);
  }

  /// Toggles the NFC enabled state.
  void toggleNFC() => emitSafe(state.copyWith(isNFCEnabled: !state.isNFCEnabled));

  /// Resets the operation success flag.
  void resetOperationStatus() => emitSafe(state.copyWith(isOperationSuccessful: false));

  /// Clears the current error message in the state.
  void clearErrorMessage() => emitSafe(state.copyWith(errorMessage: null));

  //---------------------------- SnackBar Control ----------------------------//
  /// Marks the SnackBar as displayed to prevent repeated UI actions.
  void markSnackBarDisplayed() => emitSafe(state.copyWith(isSnackBarDisplayed: true));

  /// Resets the SnackBar state for future displays.
  void resetSnackBarState() => emitSafe(state.copyWith(isSnackBarDisplayed: false));

  //----------------------------- Error Recovery -----------------------------//
  /// Restarts the NFC session if no processing is ongoing and NFC is disabled.
  Future<void> restartSessionIfNeeded({CardEntity? card}) async {
    if (!state.isProcessing && !state.isNFCEnabled) {
      try {
        logger.i('Restarting NFC session...');
        await start(card: card);
      } catch (e) {
        logger.e('Failed to restart NFC session: $e');
        emitSafe(state.copyWith(errorMessage: 'Failed to restart session: $e'));
      }
    }
  }

  //----------------------------- Session Control ----------------------------//
  /// Starts the NFC session for reading or writing.
  Future<void> start({CardEntity? card}) async {
    logger.i(card == null ? 'Start NFC Read Process...' : 'Start NFC Write Process...');
    await _startSession(card == null ? _processRead : (tag) => _processWrite(tag, card));
  }

  /// Internal function to manage NFC session lifecycle.
  Future<void> _startSession(Future<void> Function(NfcTag) onDiscovered) async {
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
          _handleError(e);
        }
      });
    } catch (e) {
      _handleError(e);
    } finally {
      emitSafe(state.copyWith(isProcessing: false));
    }
  }

  /// Stops the current NFC session and updates the state.
  Future<void> stopSession({String? reason}) async {
    try {
      logger.i('Stopping NFC session: $reason');
      await NfcManager.instance.stopSession();
      emitSafe(state.copyWith(isNFCEnabled: false));
      logger.i('NFC session stopped successfully.');
    } catch (e) {
      logger.e('Error stopping NFC session: $e');
      emitSafe(state.copyWith(errorMessage: 'Error stopping NFC session: $e'));
    }
  }

  //------------------------------- Processing -------------------------------//
  /// Processes an NFC tag for reading.
  Future<void> _processRead(NfcTag tag) async {
    final ndef = _validateNDEF(tag);
    final parsedRecords = _parseNDEFRecords(ndef);
    final tagEntity = _createTagEntity(tag, parsedRecords);

    logger.i('Tag Read Successful: $tagEntity');
    emitSafe(state.copyWith(lastReadTag: tagEntity, isOperationSuccessful: true));
  }

  /// Processes an NFC tag for writing.
  Future<void> _processWrite(NfcTag tag, CardEntity card) async {
    final ndef = _validateNDEF(tag);
    final ndefMessage = _createNDEFMessage(card);

    await _testWrite(ndef);
    await ndef.write(ndefMessage);

    logger.i('NFC Write Successful.');
    emitSafe(state.copyWith(isOperationSuccessful: true));
  }

  //--------------------------- Validation Helpers ---------------------------//
  /// Validates the NFC tag for NDEF compatibility.
  Ndef _validateNDEF(NfcTag tag) {
    final ndef = Ndef.from(tag);
    if (ndef == null) throw Exception('Tag does not support NDEF.');
    if (!ndef.isWritable) throw Exception('This tag is read-only and cannot be written to.');
    return ndef;
  }

  /// Tests writing capability of an NFC tag.
  Future<void> _testWrite(Ndef ndef) async {
    try {
      await ndef.write(NdefMessage([NdefRecord.createText('Test')]));
    } catch (_) {
      throw Exception('The tag is locked or cannot be written to.');
    }
  }

  /// Parses the NDEF records from an NFC tag.
  List<String> _parseNDEFRecords(Ndef ndef) {
    final ndefMessage = ndef.cachedMessage;
    if (ndefMessage == null) throw Exception('No NDEF message found on the tag.');

    final records = ndefMessage.records.map((record) {
      try {
        return String.fromCharCodes(record.payload).substring(3);
      } catch (_) {
        throw Exception('Encoding format on the tag is incompatible.');
      }
    }).toList();

    if (records.isEmpty) throw Exception('No data found in the NDEF records.');
    return records;
  }

  /// Creates an NDEF message for writing.
  NdefMessage _createNDEFMessage(CardEntity card) {
    final message = NdefMessage([
      NdefRecord.createText('game: ${card.game}'),
      NdefRecord.createText('id: ${card.cardId}'),
    ]);

    if (message.byteLength > 180) throw Exception('Data exceeds the tag capacity.');
    return message;
  }

  /// Creates a `TagEntity` from NFC tag data.
  TagEntity _createTagEntity(NfcTag tag, List<String> parsedRecords) {
    final game = parsedRecords.firstWhere((record) => record.startsWith('game:'), orElse: () => '').split(': ').last;
    final cardId = parsedRecords.firstWhere((record) => record.startsWith('id:'), orElse: () => '').split(': ').last;
    final tagId = _extractTagId(tag);

    if (game.isEmpty || cardId.isEmpty || tagId.isEmpty) {
      throw Exception('Incomplete data.');
    }

    return TagEntity(tagId: tagId, cardId: cardId, game: game, timestamp: DateTime.now());
  }

  /// Extracts the tag ID from an NFC tag.
  String _extractTagId(NfcTag tag) {
    return (tag.data['nfca']?['identifier'] as List<dynamic>?)
            ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(':') ?? '';
  }

  //----------------------------- Error Handling -----------------------------//
  /// Handles errors and updates the state with error messages.
  void _handleError(dynamic error) {
    logger.e('Error: $error');
    emitSafe(state.copyWith(errorMessage: error.toString()));
  }
}
