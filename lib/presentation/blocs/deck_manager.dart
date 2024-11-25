import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/deck.dart';
import '../../domain/usecases/deck_manager.dart';

class DeckMangerState {
  final DeckEntity deck;
  final bool isEditMode;
  final bool isShareEnabled;
  final bool isNfcReadEnabled;
  final bool isDeleteEnabled;
  final CardEntity? selectedCard;

  DeckMangerState({
    required this.deck,
    this.isEditMode = false,
    this.isShareEnabled = false,
    this.isNfcReadEnabled = false,
    this.isDeleteEnabled = false,
    this.selectedCard,
  });

  DeckMangerState copyWith({
    DeckEntity? deck,
    bool? isEditMode,
    bool? isShareEnabled,
    bool? isNfcReadEnabled,
    bool? isDeleteEnabled,
    CardEntity? selectedCard,
  }) {
    return DeckMangerState(
      deck: deck ?? this.deck,
      isEditMode: isEditMode ?? this.isEditMode,
      isShareEnabled: isShareEnabled ?? this.isShareEnabled,
      isNfcReadEnabled: isNfcReadEnabled ?? this.isNfcReadEnabled,
      isDeleteEnabled: isDeleteEnabled ?? this.isDeleteEnabled,
      selectedCard: selectedCard ?? this.selectedCard,
    );
  }
}

class DeckMangerCubit extends Cubit<DeckMangerState> {
  final AddCardUseCase addCardUseCase = AddCardUseCase();
  final RemoveCardUseCase removeCardUseCase = RemoveCardUseCase();

  DeckMangerCubit()
      : super(
          DeckMangerState(
            deck: DeckEntity(
              deckId: 'default',
              deckName: 'Default Deck',
              cards: {},
            ),
          ),
        );

  void setDeck(DeckEntity deck) {
    emit(state.copyWith(deck: deck));
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
    emit(state.copyWith(isNfcReadEnabled: false));
  }

  void toggleShare() {
    final deck = state.deck;

    final StringBuffer clipboardContent = StringBuffer()
      ..writeln('Game: ${deck.games.join(", ")}')
      ..writeln('Deck Name: ${deck.deckName}')
      ..writeln('Deck ID: ${deck.deckId}')
      ..writeln('Total Cards: ${deck.totalCards}')
      ..writeln('\nCards:');

    deck.cards.forEach((card, count) {
      clipboardContent
        ..writeln('- ${card.name} (ID: ${card.cardId}) x$count')
        ..writeln('  Description: ${card.description ?? "N/A"}');
    });

    Clipboard.setData(ClipboardData(text: clipboardContent.toString()));

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
    emit(state.copyWith(deck: clearedDeck, isDeleteEnabled: false));
  }
}
