import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/tag.dart';

class NFCState {
  final bool isNFCEnabled;
  final TagEntity? lastReadTag;
  final String? errorMessage;
  final bool isOperationSuccessful;

  NFCState({
    required this.isNFCEnabled,
    this.lastReadTag,
    this.errorMessage,
    this.isOperationSuccessful = false,
  });

  NFCState copyWith({
    bool? isNFCEnabled,
    TagEntity? lastReadTag,
    String? errorMessage,
    bool? isOperationSuccessful,
  }) {
    return NFCState(
      isNFCEnabled: isNFCEnabled ?? this.isNFCEnabled,
      lastReadTag: lastReadTag,
      errorMessage: errorMessage,
      isOperationSuccessful:
          isOperationSuccessful ?? this.isOperationSuccessful,
    );
  }
}

class NFCCubit extends Cubit<NFCState> {
  NFCCubit()
      : super(
          NFCState(
            isNFCEnabled: false,
          ),
        );

  void toggleNFC() {
    emit(state.copyWith(isNFCEnabled: !state.isNFCEnabled));
  }

  Future<void> startRead() async {
    try {
      if (!await NfcManager.instance.isAvailable()) {
        emit(state.copyWith(errorMessage: 'NFC is not available'));
        return;
      }
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag);
            if (ndef == null || !ndef.isWritable) {
              emit(state.copyWith(errorMessage: 'Tag is not writable or null'));
              return;
            }
            // ignore: unused_local_variable
            final message = ndef.cachedMessage;
            final tagId = tag.data['id'].toString();
            final tagEntity = TagEntity(
              tagId: tagId,
              cardId: '',
              game: '',
              timestamp: DateTime.now(),
            );
            emit(state.copyWith(lastReadTag: tagEntity));
            NfcManager.instance.stopSession();
          } catch (e) {
            emit(state.copyWith(errorMessage: 'Error reading NFC tag: $e'));
            NfcManager.instance.stopSession(errorMessage: e.toString());
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> startWrite(CardEntity card) async {
    try {
      if (!await NfcManager.instance.isAvailable()) {
        emit(state.copyWith(errorMessage: 'NFC is not available'));
        return;
      }
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag);
            if (ndef == null || !ndef.isWritable) {
              emit(state.copyWith(errorMessage: 'Tag is not writable'));
              return;
            }
            final ndefMessage = NdefMessage([
              NdefRecord.createText('Card Name: ${card.name}'),
              NdefRecord.createText('Game: ${card.game}'),
              NdefRecord.createText('Card ID: ${card.cardId}'),
            ]);
            await ndef.write(ndefMessage);
            emit(state.copyWith(
                isOperationSuccessful: true, errorMessage: null));
            NfcManager.instance.stopSession();
          } catch (e) {
            emit(state.copyWith(errorMessage: 'Error writing NFC tag: $e'));
            NfcManager.instance.stopSession(errorMessage: e.toString());
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void stopSession() {
    emit(state.copyWith(isNFCEnabled: false));
    try {
      NfcManager.instance.stopSession();
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Error stopping NFC session: $e'));
    }
  }
}
