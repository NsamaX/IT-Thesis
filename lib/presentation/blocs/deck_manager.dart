import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/deck.dart';
import '../../domain/usecases/deck_manager.dart';

class DeckManagerState {
  final List<DeckEntity> allDecks;
  final DeckEntity deck;
  final bool isEditMode;
  final bool isShareEnabled;
  final bool isNfcReadEnabled;
  final bool isDeleteEnabled;
  final CardEntity? selectedCard;

  DeckManagerState({
    required this.allDecks,
    required this.deck,
    this.isEditMode = false,
    this.isShareEnabled = false,
    this.isNfcReadEnabled = false,
    this.isDeleteEnabled = false,
    this.selectedCard,
  });

  DeckManagerState copyWith({
    List<DeckEntity>? allDecks,
    DeckEntity? deck,
    bool? isEditMode,
    bool? isShareEnabled,
    bool? isNfcReadEnabled,
    bool? isDeleteEnabled,
    CardEntity? selectedCard,
  }) {
    return DeckManagerState(
      allDecks: allDecks ?? this.allDecks,
      deck: deck ?? this.deck,
      isEditMode: isEditMode ?? this.isEditMode,
      isShareEnabled: isShareEnabled ?? this.isShareEnabled,
      isNfcReadEnabled: isNfcReadEnabled ?? this.isNfcReadEnabled,
      isDeleteEnabled: isDeleteEnabled ?? this.isDeleteEnabled,
      selectedCard: selectedCard ?? this.selectedCard,
    );
  }
}

class DeckManagerCubit extends Cubit<DeckManagerState> {
  final AddCardUseCase addCardUseCase;
  final RemoveCardUseCase removeCardUseCase;
  final SaveDeckUseCase saveDeckUseCase;
  final LoadDecksUseCase loadDecksUseCase;
  final DeleteDeckUseCase deleteDeckUseCase;

  DeckManagerCubit({
    required this.addCardUseCase,
    required this.removeCardUseCase,
    required this.saveDeckUseCase,
    required this.loadDecksUseCase,
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

  Future<void> loadDecks() async {
    final decks = await loadDecksUseCase.call();
    emit(state.copyWith(allDecks: decks));
  }

  Future<void> saveDeck() async {
    if (state.deck.cards.isEmpty) {
      await deleteDeck();
      return;
    }
    await saveDeckUseCase(state.deck);
    final updatedDecks = List<DeckEntity>.from(state.allDecks);
    final existingIndex =
        updatedDecks.indexWhere((deck) => deck.deckId == state.deck.deckId);

    if (existingIndex != -1) {
      updatedDecks[existingIndex] = state.deck;
    } else {
      updatedDecks.add(state.deck);
    }
    emit(state.copyWith(allDecks: updatedDecks));
  }

  Future<void> deleteDeck() async {
    final deckId = state.deck.deckId;
    await deleteDeckUseCase(deckId);
    final updatedDecks =
        state.allDecks.where((deck) => deck.deckId != deckId).toList();
    emit(state.copyWith(
      allDecks: updatedDecks,
      deck: updatedDecks.isNotEmpty
          ? updatedDecks.first
          : DeckEntity(deckId: Uuid().v4(), deckName: 'New Deck', cards: {}),
    ));
  }

  void setDeck(DeckEntity deck) {
    emit(state.copyWith(deck: deck));
  }

  void renameDeck(String newDeckName) {
    final updatedDeck = state.deck.copyWith(deckName: newDeckName);
    emit(state.copyWith(deck: updatedDeck));
  }

  void addCard(CardEntity card) {
    final updatedDeck = addCardUseCase(state.deck, card);
    emit(state.copyWith(deck: updatedDeck));
  }

  void removeCard(CardEntity card) {
    final updatedDeck = removeCardUseCase(state.deck, card);
    emit(state.copyWith(deck: updatedDeck));
  }

  void toggleEditMode() {
    emit(state.copyWith(isEditMode: !state.isEditMode));
  }

  void toggleShare() {
    final deck = state.deck;
    final StringBuffer clipboardContent = StringBuffer()
      ..writeln('Deck Name: ${deck.deckName}')
      ..writeln('Deck ID: ${deck.deckId}')
      ..writeln('Total Cards: ${deck.totalCards}')
      ..writeln('\nCards:');

    deck.cards.forEach((card, count) {
      clipboardContent
        ..writeln('- ${card.name} (ID: ${card.cardId}) x$count')
        ..writeln('  Description: ${card.description ?? "N/A"}');
    });
    emit(state.copyWith(isShareEnabled: true));
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
}
