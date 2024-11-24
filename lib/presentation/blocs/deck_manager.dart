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

  DeckMangerState({
    required this.deck,
    this.isEditMode = false,
    this.isShareEnabled = false,
    this.isNfcReadEnabled = false,
    this.isDeleteEnabled = false,
  });

  DeckMangerState copyWith({
    DeckEntity? deck,
    bool? isEditMode,
    bool? isShareEnabled,
    bool? isNfcReadEnabled,
    bool? isDeleteEnabled,
  }) {
    return DeckMangerState(
      deck: deck ?? this.deck,
      isEditMode: isEditMode ?? this.isEditMode,
      isShareEnabled: isShareEnabled ?? this.isShareEnabled,
      isNfcReadEnabled: isNfcReadEnabled ?? this.isNfcReadEnabled,
      isDeleteEnabled: isDeleteEnabled ?? this.isDeleteEnabled,
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
              cards: [],
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
  }

  void toggleShare() {
    emit(state.copyWith(isShareEnabled: !state.isShareEnabled));
  }

  void toggleNfcRead() {
    emit(state.copyWith(isNfcReadEnabled: !state.isNfcReadEnabled));
  }

  void toggleDelete() {
    emit(state.copyWith(isDeleteEnabled: !state.isDeleteEnabled));
  }
}
