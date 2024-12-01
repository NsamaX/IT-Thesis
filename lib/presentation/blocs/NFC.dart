import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:logger/logger.dart';
import '../../../domain/entities/card.dart';
import '../../../domain/entities/tag.dart';
import '../../../domain/usecases/tag.dart';

class NFCState {
  final bool isNFCEnabled;
  final TagEntity? lastReadTag;
  final String? errorMessage;
  final bool isOperationSuccessful;
  final List<Map<TagEntity, CardEntity>>? savedTags;

  NFCState({
    required this.isNFCEnabled,
    this.lastReadTag,
    this.errorMessage,
    this.isOperationSuccessful = false,
    this.savedTags,
  });

  NFCState copyWith({
    bool? isNFCEnabled,
    TagEntity? lastReadTag,
    String? errorMessage,
    bool? isOperationSuccessful,
    List<Map<TagEntity, CardEntity>>? savedTags,
  }) {
    return NFCState(
      isNFCEnabled: isNFCEnabled ?? this.isNFCEnabled,
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

  static const String nfcUnavailableMessage =
      'NFC is not available on this device.';
  static const String tagNotWritableMessage =
      'The detected tag is not writable. Please try another tag.';
  static const String tagTooLargeMessage =
      'The data exceeds the tag\'s capacity. Please reduce the size of the data.';

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
    if (!isClosed) {
      emit(state);
    } else {
      logger.w('Tried to emit on a closed Cubit.');
    }
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
    if (card == null) {
      logger.i('Start NFC Read Process...');
      await startRead();
    } else {
      logger.i('Start NFC Write Process...');
      await startWrite(card);
    }
  }

  void stopSession({String? errorMessage}) {
    try {
      NfcManager.instance.stopSession(errorMessage: errorMessage);
      emitSafe(state.copyWith(isNFCEnabled: false));
      logger.i('NFC session stopped successfully.');
    } catch (e) {
      logger.e('Error stopping NFC session: $e');
      emitSafe(state.copyWith(errorMessage: 'Error stopping NFC session: $e'));
    }
  }

  String parseTextFromPayload(List<int> payload) {
    if (payload.length < 3) return '';
    return String.fromCharCodes(payload.sublist(3));
  }

  Future<void> startRead() async {
    logger.i('Starting NFC read session...');
    try {
      if (!await NfcManager.instance.isAvailable()) {
        logger.e(nfcUnavailableMessage);
        emit(state.copyWith(errorMessage: nfcUnavailableMessage));
        return;
      }

      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            final ndef = Ndef.from(tag);
            if (ndef == null) {
              throw Exception('No NDEF data found on the tag.');
            }

            final cachedMessage = tag.data['ndef']?['cachedMessage'];
            String? game;
            String? cardId;

            if (cachedMessage != null && cachedMessage['records'] != null) {
              for (var record in (cachedMessage['records'] as List<dynamic>)) {
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
              throw Exception('Unable to read tag ID.');
            }

            final tagEntity = TagEntity(
              tagId: tagId,
              cardId: cardId ?? '',
              game: game ?? '',
              timestamp: DateTime.now(),
            );

            logger.i('Tag Read Successful: $tagEntity');
            emit(state.copyWith(lastReadTag: tagEntity));
          } catch (e) {
            logger.e('Error during NFC read: $e');
            emit(state.copyWith(errorMessage: 'Error reading NFC tag: $e'));
            stopSession(errorMessage: e.toString());
          }
        },
      );
    } catch (e) {
      logger.e('Error initializing NFC session: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> startWrite(CardEntity card) async {
    logger.i('Starting NFC write session...');
    try {
      if (!await NfcManager.instance.isAvailable()) {
        logger.e(NFCCubit.nfcUnavailableMessage);
        emit(state.copyWith(errorMessage: NFCCubit.nfcUnavailableMessage));
        return;
      }

      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            logger.d('Tag discovered: ${tag.data}');

            final ndef = Ndef.from(tag);
            if (ndef == null) {
              logger.e('Tag does not support NDEF.');
              emit(state.copyWith(
                  errorMessage:
                      'This tag does not support NDEF. Please try another tag.'));
              stopSession(errorMessage: 'Tag does not support NDEF.');
              return;
            }

            if (!ndef.isWritable) {
              logger.e('Tag is not writable.');
              emit(state.copyWith(
                  errorMessage:
                      'This tag is read-only. Please use a writable tag.'));
              stopSession(errorMessage: 'Tag is read-only.');
              return;
            }

            final ndefMessage = NdefMessage([
              NdefRecord.createText('Card Name: ${card.name}'),
              NdefRecord.createText('Game: ${card.game}'),
              NdefRecord.createText('Card ID: ${card.cardId}'),
            ]);

            if (ndefMessage.byteLength > ndef.maxSize) {
              logger.e('Data size exceeds tag capacity.');
              emit(state.copyWith(
                  errorMessage:
                      'Data exceeds tag capacity. Reduce data size.'));
              stopSession(errorMessage: 'Data exceeds tag capacity.');
              return;
            }

            await ndef.write(ndefMessage);
            logger.i('NFC Write Successful.');

            final tagId = (tag.data['nfca']?['identifier'] as List<dynamic>?)
                ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join(':');

            final tagEntity = TagEntity(
              tagId: tagId ?? '',
              cardId: card.cardId,
              game: card.game,
              timestamp: DateTime.now(),
            );

            await saveTagWithCard(tagEntity, card);
            emit(state.copyWith(
                isOperationSuccessful: true, errorMessage: null));
          } catch (e) {
            logger.e('Error during NFC write: $e');
            emit(state.copyWith(errorMessage: 'Error writing NFC tag: $e'));
            stopSession(errorMessage: e.toString());
          }
        },
      );
    } catch (e) {
      logger.e('Error initializing NFC session: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> saveTagWithCard(
      TagEntity tagEntity, CardEntity cardEntity) async {
    try {
      await saveTagUseCase(tagEntity, cardEntity);
      logger.i('Tag and Card saved successfully.');
      await loadTags();
    } catch (e) {
      logger.e('Error saving tag and card: $e');
      emit(state.copyWith(errorMessage: 'Error saving tag and card: $e'));
    }
  }

  Future<void> loadTags() async {
    try {
      final tagsWithCards = await loadTagsUseCase();
      if (isClosed) return;
      emit(state.copyWith(savedTags: tagsWithCards));
      logger.i('Tags and Cards loaded successfully.');
    } catch (e) {
      logger.e('Error loading tags and cards: $e');
      emit(state.copyWith(errorMessage: 'Error loading tags and cards: $e'));
    }
  }
}
