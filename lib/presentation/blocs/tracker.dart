import 'package:flutter_bloc/flutter_bloc.dart';
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
    bool? isNfcReadEnabled,
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

  int get totalCards => state.deck.cards.values.fold(0, (sum, count) => sum + count);

  void draw() {}

  void returnToDeck() {}
}