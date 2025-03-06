import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

import 'package:nfc_project/core/utils/nfc_helper.dart';

import 'package:nfc_project/domain/usecases/deck.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import 'package:nfc_project/domain/entities/card.dart';

import '../NFC/cubit.dart';

part 'state.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class DeckManagerCubit extends Cubit<DeckManagerState> {
  final AddCardUseCase addCardUseCase;
  final RemoveCardUseCase removeCardUseCase;
  final SaveDeckUseCase saveDeckUseCase;
  final DeleteDeckUseCase deleteDeckUseCase;
  final LoadDecksUseCase loadDecksUseCase;

  DeckManagerCubit({
    required this.addCardUseCase,
    required this.removeCardUseCase,
    required this.saveDeckUseCase,
    required this.deleteDeckUseCase,
    required this.loadDecksUseCase,
  }) : super(DeckManagerState(
    decks: [],
    deck: DeckEntity(deckId: Uuid().v4(), deckName: 'Default Deck', cards: {}),
  ));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void toggleEditMode() => emit(state.copyWith(isEditModeEnabled: !state.isEditModeEnabled, isNFCEnabled: false));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void toggleShare() {
    Clipboard.setData(ClipboardData(
      text: [
        'Deck Name: ${state.deck.deckName}',
        'Total Cards: ${state.deck.cards.values.fold(0, (total, count) => total + count)}',
        ...state.deck.cards.entries.map((e) => '- [${e.value}] ${e.key.name}')
      ].join('\n'),
    ));
    emit(state.copyWith(isShareEnabled: true));
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void toggleNFC(NFCCubit nfcCubit) {
    final enabled = !state.isNFCEnabled;
    emit(state.copyWith(isNFCEnabled: enabled));
    if (!enabled) {
      NFCHelper.handleToggleNFC(nfcCubit, enable: false, reason: 'NFC disabled');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void toggleSelectCard(CardEntity card) => emit(state.copyWith(selectedCard: state.selectedCard == card ? null : card));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void toggleDelete() => emit(state.copyWith(deck: state.deck.copyWith(cards: {})));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void setQuantity(int quantity) => emit(state.copyWith(quantity: quantity));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void addCard(CardEntity card, int count) => emit(state.copyWith(deck: addCardUseCase(state.deck, card, count)));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void removeCard(CardEntity card) => emit(state.copyWith(deck: removeCardUseCase(state.deck, card)));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void setDeck(DeckEntity deck) => emit(state.copyWith(deck: deck));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void renameDeck(String newDeckName) => emit(state.copyWith(deck: state.deck.copyWith(deckName: newDeckName)));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> saveDeck(NFCCubit nfcCubit) async {
    await _performWithLoading(() async {
      await saveDeckUseCase(state.deck);
      final updatedDecks = [...state.decks];
      final index = updatedDecks.indexWhere((d) => d.deckId == state.deck.deckId);
      if (index != -1) {
        updatedDecks[index] = state.deck;
      } else {
        updatedDecks.add(state.deck);
      }
      emit(state.copyWith(decks: updatedDecks));
    });
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> deleteDeck(DeckEntity deckToDelete) async {
    await deleteDeckUseCase(deckToDelete.deckId);
    final updatedDecks = state.decks.where((d) => d.deckId != deckToDelete.deckId).toList();
    emit(state.copyWith(
      decks: updatedDecks,
      deck: updatedDecks.isNotEmpty
          ? updatedDecks.first
          : DeckEntity(deckId: Uuid().v4(), deckName: 'Default Deck', cards: {}),
    ));
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> loadDecks() async {
    final decks = await loadDecksUseCase.call();
    if (!isClosed) {
      emit(state.copyWith(decks: decks.where((d) => d.cards.isNotEmpty).toList()));
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> _performWithLoading(Future<void> Function() task) async {
    emit(state.copyWith(isLoading: true));
    try {
      await task();
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
