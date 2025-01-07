import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import 'package:nfc_project/domain/usecases/deck_manager.dart';
import 'NFC.dart';

class DeckManagerState {
  final List<DeckEntity> allDecks;
  final DeckEntity deck;
  final CardEntity? selectedCard;
  final int quantity;
  final bool isShareEnabled;
  final bool isEditMode;
  final bool isNfcReadEnabled;
  final bool isDeleteEnabled;
  final bool isLoading;

  DeckManagerState({
    required this.allDecks,
    required this.deck,
    this.selectedCard,
    this.quantity = 1,
    this.isShareEnabled = false,
    this.isEditMode = false,
    this.isNfcReadEnabled = false,
    this.isDeleteEnabled = false,
    this.isLoading = false,
  });

  DeckManagerState copyWith({
    List<DeckEntity>? allDecks,
    DeckEntity? deck,
    CardEntity? selectedCard,
    int? quantity,
    bool? isShareEnabled,
    bool? isEditMode,
    bool? isNfcReadEnabled,
    bool? isDeleteEnabled,
    bool? isLoading,
  }) => DeckManagerState(
    allDecks: allDecks ?? this.allDecks,
    deck: deck ?? this.deck,
    selectedCard: selectedCard ?? this.selectedCard,
    quantity: quantity ?? this.quantity,
    isShareEnabled: isShareEnabled ?? this.isShareEnabled,
    isEditMode: isEditMode ?? this.isEditMode,
    isNfcReadEnabled: isNfcReadEnabled ?? this.isNfcReadEnabled,
    isDeleteEnabled: isDeleteEnabled ?? this.isDeleteEnabled,
    isLoading: isLoading ?? this.isLoading,
  );
}

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
    allDecks: [],
    deck: DeckEntity(deckId: Uuid().v4(), deckName: 'Default Deck', cards: {}),
  ));

  void setDeck(DeckEntity deck) => emit(state.copyWith(deck: deck));

  void toggleShare() {
    Clipboard.setData(ClipboardData(
      text: [
        'Deck Name: ${state.deck.deckName}',
        'Total Cards: ${state.deck.totalCards}',
        ...state.deck.cards.entries.map((e) => '- [${e.value}] ${e.key.name}')
      ].join('\n'),
    ));
    emit(state.copyWith(isShareEnabled: true));
  }

  void toggleEditMode() => emit(state.copyWith(
    isEditMode: !state.isEditMode,
    isNfcReadEnabled: false,
  ));

  void toggleNfcRead(NFCCubit nfcCubit) {
    final enabled = !state.isNfcReadEnabled;
    emit(state.copyWith(isNfcReadEnabled: enabled));
    if (!enabled) NFCHelper.handleToggleNFC(nfcCubit, enable: false, reason: 'NFC disabled');
  }

  void toggleSelectedCard(CardEntity card) => emit(
    state.copyWith(selectedCard: state.selectedCard == card ? null : card));

  Future<void> writeSelectedCardToNFC(NFCCubit nfcCubit) async {
    if (!state.isNfcReadEnabled || state.selectedCard == null) return;
    try {
      emit(state.copyWith(isLoading: true));
      await NFCHelper.handleToggleNFC(nfcCubit, enable: true, card: state.selectedCard!);
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void toggleDelete() => emit(
    state.copyWith(deck: state.deck.copyWith(cards: {})));

  void renameDeck(String newDeckName) => emit(
    state.copyWith(deck: state.deck.copyWith(deckName: newDeckName)));

  void setQuantity(int quantity) => emit(
    state.copyWith(quantity: quantity));

  void addCard(CardEntity card, int count) => emit(
    state.copyWith(deck: addCardUseCase(state.deck, card, count)));

  void removeCard(CardEntity card) => emit(
    state.copyWith(deck: removeCardUseCase(state.deck, card)));

  Future<void> saveDeck(NFCCubit nfcCubit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await saveDeckUseCase(state.deck);
      final updatedDecks = [...state.allDecks];
      final index = updatedDecks.indexWhere((d) => d.deckId == state.deck.deckId);
      if (index != -1) {
        updatedDecks[index] = state.deck;
      } else {
        updatedDecks.add(state.deck);
      }
      emit(state.copyWith(allDecks: updatedDecks));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> deleteDeck(DeckEntity deckToDelete) async {
    await deleteDeckUseCase(deckToDelete.deckId);
    final updatedDecks = state.allDecks.where((d) => d.deckId != deckToDelete.deckId).toList();
    emit(state.copyWith(
      allDecks: updatedDecks,
      deck: updatedDecks.isNotEmpty
          ? updatedDecks.first
          : DeckEntity(deckId: Uuid().v4(), deckName: 'Default Deck', cards: {}),
    ));
  }

  Future<void> loadDecks() async {
    final decks = await loadDecksUseCase.call();
    emit(state.copyWith(allDecks: decks.where((d) => d.cards.isNotEmpty).toList()));
  }
}
