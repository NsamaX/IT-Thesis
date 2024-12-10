import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import 'package:nfc_project/domain/usecases/deck_manager.dart';

class DeckManagerState {
  final List<DeckEntity> allDecks;
  final DeckEntity deck;
  final bool isLoading;
  final bool isShareEnabled;
  final bool isNfcReadEnabled;
  final bool isDeleteEnabled;
  final bool isEditMode;
  final CardEntity? selectedCard;

  DeckManagerState({
    required this.allDecks,
    required this.deck,
    this.isLoading = false,
    this.isShareEnabled = false,
    this.isNfcReadEnabled = false,
    this.isDeleteEnabled = false,
    this.isEditMode = false,
    this.selectedCard,
  });

  DeckManagerState copyWith({
    List<DeckEntity>? allDecks,
    DeckEntity? deck,
    bool? isLoading,
    bool? isShareEnabled,
    bool? isNfcReadEnabled,
    bool? isDeleteEnabled,
    bool? isEditMode,
    CardEntity? selectedCard,
  }) {
    return DeckManagerState(
      allDecks: allDecks ?? this.allDecks,
      deck: deck ?? this.deck,
      isLoading: isLoading ?? this.isLoading,
      isShareEnabled: isShareEnabled ?? this.isShareEnabled,
      isNfcReadEnabled: isNfcReadEnabled ?? this.isNfcReadEnabled,
      isDeleteEnabled: isDeleteEnabled ?? this.isDeleteEnabled,
      isEditMode: isEditMode ?? this.isEditMode,
      selectedCard: selectedCard ?? this.selectedCard,
    );
  }
}

class DeckManagerCubit extends Cubit<DeckManagerState> {
  final AddCardUseCase addCardUseCase;
  final RemoveCardUseCase removeCardUseCase;
  final LoadDecksUseCase loadDecksUseCase;
  final SaveDeckUseCase saveDeckUseCase;
  final DeleteDeckUseCase deleteDeckUseCase;

  DeckManagerCubit({
    required this.addCardUseCase,
    required this.removeCardUseCase,
    required this.loadDecksUseCase,
    required this.saveDeckUseCase,
    required this.deleteDeckUseCase,
  }) : super(
          DeckManagerState(
            allDecks: [],
            deck: DeckEntity(
              deckId: Uuid().v4(),
              deckName: 'Default Deck',
              cards: {},
            ),
          ),
        );

  void setDeck(DeckEntity deck) {
    emit(state.copyWith(deck: deck));
  }

  void toggleShare() {
    final deck = state.deck;
    final StringBuffer clipboardContent = StringBuffer()
      ..writeln('Deck ID: ${deck.deckId}')
      ..writeln('Deck Name: ${deck.deckName}')
      ..writeln('Total Cards: ${deck.totalCards}')
      ..writeln('\nCards:');
    deck.cards.forEach((card, count) {
      clipboardContent..writeln('- ${card.name} (ID: ${card.cardId}) x$count');
    });
    Clipboard.setData(ClipboardData(text: clipboardContent.toString()));
    emit(state.copyWith(isShareEnabled: true));
  }

  void renameDeck(String newDeckName) {
    final updatedDeck = state.deck.copyWith(deckName: newDeckName);
    emit(state.copyWith(deck: updatedDeck));
  }

  void toggleNfcRead() {
    emit(state.copyWith(isNfcReadEnabled: !state.isNfcReadEnabled));
  }

  void toggleSelectedCard(CardEntity card) {
    emit(
        state.copyWith(selectedCard: state.selectedCard == card ? null : card));
  }

  void toggleDelete() {
    final clearedDeck = state.deck.copyWith(cards: {});
    emit(state.copyWith(deck: clearedDeck));
  }

  void toggleEditMode() {
    emit(state.copyWith(isEditMode: !state.isEditMode));
    emit(state.copyWith(isNfcReadEnabled: false));
  }

  void addCard(CardEntity card) {
    final updatedDeck = addCardUseCase(state.deck, card);
    emit(state.copyWith(deck: updatedDeck));
  }

  void removeCard(CardEntity card) {
    final updatedDeck = removeCardUseCase(state.deck, card);
    emit(state.copyWith(deck: updatedDeck));
  }

  Future<void> loadDecks() async {
    final decks = await loadDecksUseCase.call();
    final filteredDecks = decks.where((deck) => deck.cards.isNotEmpty).toList();
    emit(state.copyWith(allDecks: filteredDecks));
  }

  Future<void> saveDeck() async {
    emit(state.copyWith(isLoading: true));
    try {
      await saveDeckUseCase(state.deck);
      final updatedDecks = List<DeckEntity>.from(state.allDecks);
      final existingIndex = updatedDecks.indexWhere((deck) => deck.deckId == state.deck.deckId);
      if (existingIndex != -1) {
        updatedDecks[existingIndex] = state.deck;
      } else {
        updatedDecks.add(state.deck);
      }
      emit(state.copyWith(allDecks: updatedDecks));
    } catch (e) {
      print("Error saving deck: $e");
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> deleteDeck(DeckEntity deckToDelete) async {
    await deleteDeckUseCase(deckToDelete.deckId);
    final updatedDecks = state.allDecks
        .where((deck) => deck.deckId != deckToDelete.deckId)
        .toList();
    emit(state.copyWith(
      allDecks: updatedDecks,
      deck: updatedDecks.isNotEmpty
          ? updatedDecks.first
          : DeckEntity(deckId: Uuid().v4(), deckName: 'Default Deck', cards: {}),
    ));
  }
}
