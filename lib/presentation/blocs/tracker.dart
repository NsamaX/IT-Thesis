import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/card.dart';
import '../../../domain/entities/deck.dart';

class TrackState {
  final DeckEntity deck;
  final bool isDialogShown;

  TrackState({
    required this.deck,
    this.isDialogShown = false,
  });

  TrackState copyWith({
    DeckEntity? deck,
    bool? isDialogShown,
  }) {
    return TrackState(
      deck: deck ?? this.deck,
      isDialogShown: isDialogShown ?? this.isDialogShown,
    );
  }
}

class TrackCubit extends Cubit<TrackState> {
  TrackCubit(DeckEntity deck) : super(TrackState(deck: deck));

  void showDialog() {
    emit(state.copyWith(isDialogShown: true));
  }

  int get totalCards =>
      state.deck.cards.values.fold(0, (sum, count) => sum + count);

  void addCard(CardEntity card) {
    final updatedDeck = Map<CardEntity, int>.from(state.deck.cards);
    updatedDeck[card] = (updatedDeck[card] ?? 0) + 1;
    emit(state.copyWith(deck: state.deck.copyWith(cards: updatedDeck)));
  }

  void removeCard(CardEntity card) {
    final updatedDeck = Map<CardEntity, int>.from(state.deck.cards);
    if (updatedDeck.containsKey(card)) {
      if (updatedDeck[card]! > 1) {
        updatedDeck[card] = updatedDeck[card]! - 1;
      } else {
        updatedDeck.remove(card);
      }
      emit(state.copyWith(deck: state.deck.copyWith(cards: updatedDeck)));
    }
  }
}
