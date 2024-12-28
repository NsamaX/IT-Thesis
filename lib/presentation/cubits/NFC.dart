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

  NFCCubit({
    required this.saveTagUseCase,
    required this.loadTagsUseCase,
  }) : super(NFCState(isNFCEnabled: false, savedTags: []));

  //----------------------------- State Control ------------------------------//
  void emitSafe(NFCState state) {
    if (!isClosed) emit(state);
  }

  void toggleNFC() => emitSafe(state.copyWith(isNFCEnabled: !state.isNFCEnabled));
  void resetOperationStatus() => emitSafe(state.copyWith(isOperationSuccessful: false));
  void clearErrorMessage() => emitSafe(state.copyWith(errorMessage: null));

  //----------------------------- Session Control ----------------------------//
  Future<void> start({CardEntity? card}) async {
    logger.i(card == null ? 'Start NFC Read Process...' : 'Start NFC Write Process...');
    await _startSession(card == null ? _processRead : (tag) => _processWrite(tag, card));
  }

  Future<void> _startSession(Future<void> Function(NfcTag) onDiscovered) async {
    if (state.isProcessing) {
      logger.w('Another NFC process is ongoing.');
      return;
    }
    emitSafe(state.copyWith(isProcessing: true));
    try {
      if (!await NfcManager.instance.isAvailable()) throw Exception('NFC is not available on this device.');
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
  Future<void> _processRead(NfcTag tag) async {
    final ndef = _validateNDEF(tag);
    final parsedRecords = _parseNDEFRecords(ndef);
    final tagEntity = _createTagEntity(tag, parsedRecords);
    logger.i('Tag Read Successful: $tagEntity');
    emitSafe(state.copyWith(lastReadTag: tagEntity, isOperationSuccessful: true));
  }

  Future<void> _processWrite(NfcTag tag, CardEntity card) async {
    final ndef = _validateNDEF(tag);
    final ndefMessage = _createNDEFMessage(card);
    await _testWrite(ndef); // Ensure the tag is writable
    await ndef.write(ndefMessage);
    logger.i('NFC Write Successful.');
    emitSafe(state.copyWith(isOperationSuccessful: true));
  }

  //--------------------------- Validation Helpers ---------------------------//
  Ndef _validateNDEF(NfcTag tag) {
    final ndef = Ndef.from(tag);
    if (ndef == null) throw Exception('Tag ไม่รองรับ NDEF');
    if (!ndef.isWritable) throw Exception('Tag นี้ไม่สามารถเขียนได้ (Read-Only)');
    return ndef;
  }

  Future<void> _testWrite(Ndef ndef) async {
    try {
      await ndef.write(NdefMessage([NdefRecord.createText('Test')]));
    } catch (_) {
      throw Exception('Tag ถูกล็อกหรือไม่สามารถเขียนได้');
    }
  }

  List<String> _parseNDEFRecords(Ndef ndef) {
    final ndefMessage = ndef.cachedMessage;
    if (ndefMessage == null) throw Exception('ไม่มีข้อความ NDEF บน Tag');
    final records = ndefMessage.records.map((record) {
      try {
        return String.fromCharCodes(record.payload).substring(3);
      } catch (_) {
        throw Exception('รูปแบบการเข้ารหัสใน Tag ไม่ตรงกัน');
      }
    }).toList();
    if (records.isEmpty) throw Exception('ไม่มีข้อมูลใน NDEF Records');
    return records;
  }

  NdefMessage _createNDEFMessage(CardEntity card) {
    final message = NdefMessage([
      NdefRecord.createText('Card Name: ${card.name}'),
      NdefRecord.createText('Game: ${card.game}'),
      NdefRecord.createText('Card ID: ${card.cardId}'),
    ]);
    if (message.byteLength > 512) throw Exception('ข้อมูลเกินความจุของ Tag');
    return message;
  }

  TagEntity _createTagEntity(NfcTag tag, List<String> parsedRecords) {
    final cardId = parsedRecords.firstWhere((record) => record.startsWith('Card ID:'), orElse: () => '').split(': ').last;
    final game = parsedRecords.firstWhere((record) => record.startsWith('Game:'), orElse: () => '').split(': ').last;
    final tagId = _extractTagId(tag);
    if (cardId.isEmpty || game.isEmpty || tagId.isEmpty) throw Exception('ข้อมูลไม่ครบถ้วน');
    return TagEntity(tagId: tagId, cardId: cardId, game: game, timestamp: DateTime.now());
  }

  String _extractTagId(NfcTag tag) {
    return (tag.data['nfca']?['identifier'] as List<dynamic>?)
            ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(':') ?? '';
  }

  //----------------------------- Error Handling -----------------------------//
  void _handleError(dynamic error) {
    logger.e('Error: $error');
    emitSafe(state.copyWith(errorMessage: error.toString()));
  }
}
