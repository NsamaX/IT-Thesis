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
      isOperationSuccessful: isOperationSuccessful ?? this.isOperationSuccessful,
    );
  }
}

class NFCCubit extends Cubit<NFCState> {
  NFCCubit() : super(NFCState(isNFCEnabled: false));

  void toggleNFC() {
    emit(state.copyWith(isNFCEnabled: !state.isNFCEnabled));
    print('NFC toggled: ${state.isNFCEnabled ? "Enabled" : "Disabled"}');
  }

  Future<void> start({CardEntity? card}) async {
    if (card == null) {
      print('Start NFC Read Process...');
      await startRead();
    } else {
      print('Start NFC Write Process...');
      await startWrite(card);
    }
  }

  void stopSession() {
    try {
      NfcManager.instance.stopSession();
      emit(state.copyWith(isNFCEnabled: false));
      print('NFC session stopped successfully.');
    } catch (e) {
      print('Error stopping NFC session: $e');
      emit(state.copyWith(errorMessage: 'Error stopping NFC session: $e'));
    }
  }

  String parseTextFromPayload(List<int> payload) {
    if (payload.length < 3) return '';
    return String.fromCharCodes(payload.sublist(3));
  }

  Future<void> startRead() async {
    print('Starting NFC read session...');
    try {
      if (!await NfcManager.instance.isAvailable()) {
        print('Error: NFC is not available');
        emit(state.copyWith(errorMessage: 'NFC is not available'));
        return;
      }
      print('NFC is available. Starting session...');
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag);
            if (ndef == null) {
              print('Error: Tag is null');
              emit(state.copyWith(errorMessage: 'Tag is null'));
              return;
            }
            final cachedMessage = tag.data['ndef']?['cachedMessage'];
            String? game;
            String? cardId;
            if (cachedMessage != null && cachedMessage['records'] != null) {
              final records = cachedMessage['records'] as List<dynamic>;
              for (var record in records) {
                final payload = record['payload'] as List<dynamic>?;
                if (payload != null) {
                  final text = parseTextFromPayload(payload.cast<int>());
                  if (text.startsWith('Game:')) {
                    game = text.replaceFirst('Game: ', '').trim();
                  } else if (text.startsWith('Card ID:')) {
                    cardId = text.replaceFirst('Card ID: ', '').trim();
                  }
                }
              }
            }
            final tagId = (tag.data['nfca']?['identifier'] as List<dynamic>?)
                ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join(':');
            if (tagId == null) {
              print('Error: Unable to read Tag id');
            } else {
              final tagEntity = TagEntity(
                tagId: tagId,
                cardId: cardId ?? '',
                game: game ?? '',
                timestamp: DateTime.now(),
              );
              print('Tag Information:');
              print('  Tag id: ${tagEntity.tagId}');
              print('  Game: ${tagEntity.game}');
              print('  Card id: ${tagEntity.cardId}');
              print('  Timestamp: ${tagEntity.timestamp}');
              emit(state.copyWith(lastReadTag: tagEntity));
            }
          } catch (e) {
            print('Error during NFC read: $e');
            emit(state.copyWith(errorMessage: 'Error reading NFC tag: $e'));
            NfcManager.instance.stopSession(errorMessage: e.toString());
          }
        },
      );
    } catch (e) {
      print('Error initializing NFC session: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> startWrite(CardEntity card) async {
    print('Starting NFC write session...');
    try {
      if (!await NfcManager.instance.isAvailable()) {
        print('Error: NFC is not available');
        emit(state.copyWith(errorMessage: 'NFC is not available'));
        return;
      }
      print('NFC is available. Starting session...');
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag);
            if (ndef == null || !ndef.isWritable) {
              print('Error: Tag is not writable or null');
              emit(state.copyWith(errorMessage: 'Tag is not writable or null'));
              return;
            }
            print('Max size of the tag: ${ndef.maxSize} bytes');
            final ndefMessage = NdefMessage([
              NdefRecord.createText('Card Name: ${card.name}'),
              NdefRecord.createText('Game: ${card.game}'),
              NdefRecord.createText('Card ID: ${card.cardId}'),
            ]);
            print('Size of data to write: ${ndefMessage.byteLength} bytes');
            if (ndefMessage.byteLength > ndef.maxSize) {
              print('Error: Data exceeds the tag\'s capacity.');
              emit(state.copyWith(
                  errorMessage: 'Data exceeds the tag\'s capacity.'));
              return;
            }
            print('Writing to tag...');
            await ndef.write(ndefMessage);
            emit(state.copyWith(
                isOperationSuccessful: true, errorMessage: null));
            print('NFC Write Successful.');
          } catch (e) {
            print('Error during NFC write: $e');
            emit(state.copyWith(errorMessage: 'Error writing NFC tag: $e'));
          } finally {
            NfcManager.instance.stopSession();
          }
        },
      );
    } catch (e) {
      print('Error initializing NFC session: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
