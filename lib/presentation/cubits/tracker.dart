import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/data.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import 'package:nfc_project/domain/entities/record.dart';
import 'package:nfc_project/domain/entities/tag.dart';

class TrackState {
  final DeckEntity deck;
  final RecordEntity record;
  final bool isDialogShown;
  final bool isProcessing;

  TrackState({
    required this.deck,
    required this.record,
    this.isDialogShown = false,
    this.isProcessing = false,
  });

  TrackState copyWith({
    DeckEntity? deck,
    RecordEntity? record,
    bool? isDialogShown,
    bool? isProcessing,
  }) {
    return TrackState(
      deck: deck ?? this.deck,
      record: record ?? this.record,
      isDialogShown: isDialogShown ?? this.isDialogShown,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class TrackCubit extends Cubit<TrackState> {
  TrackCubit(DeckEntity deck)
      : super(TrackState(
          deck: deck.copyWith(cards: Map.of(deck.cards)),
          record: RecordEntity(
            recordId: DateTime.now().toIso8601String(),
            createdAt: DateTime.now(),
            data: [],
          ),
        )) {
    }

  void showDialog() {
    emit(state.copyWith(isDialogShown: true));
  }

  int get totalCards => state.deck.cards.values.fold(0, (total, count) => total + count);

  void toggleReset(DeckEntity deck) {
    emit(state.copyWith(
      isProcessing: false,
      isDialogShown: true,
      deck: deck.copyWith(
        cards: Map.of(deck.cards),
      ),
      record: RecordEntity(
        recordId: DateTime.now().toIso8601String(),
        createdAt: DateTime.now(),
        data: [],
      ),
    ));
  }

  void readTag(TagEntity tag) {
    if (state.isProcessing) return;
    emit(state.copyWith(isProcessing: true));
    final existingData = state.record.data.lastWhere(
      (data) => data.tagId == tag.tagId,
      orElse: () => DataEntity(
        tagId: tag.tagId,
        location: "deck",
        action: Action.unknown,
        timestamp: DateTime.now(),
      ),
    );
    if (existingData.action == Action.draw) {
      _updateCardCount(tag, Action.returnToDeck, "deck", 1);
    } else if (existingData.action == Action.returnToDeck ||
        existingData.action == Action.unknown) {
      _updateCardCount(tag, Action.draw, "out", -1);
    }
    _moveCardToTop(tag);
    emit(state.copyWith(isProcessing: false));
  }

  void _updateCardCount(TagEntity tag, Action action, String location, int delta) {
    try {
      final cardEntry = state.deck.cards.entries.firstWhere(
        (entry) => entry.key.cardId == tag.cardId,
        orElse: () => throw Exception("Card not found in deck"),
      );
      final currentCount = state.deck.cards[cardEntry.key] ?? 0;
      if ((currentCount + delta) < 0) return;
      final updatedCards = Map.of(state.deck.cards);
      updatedCards[cardEntry.key] = (updatedCards[cardEntry.key]! + delta)
          .clamp(0, double.infinity)
          .toInt();
      final newData = DataEntity(
        tagId: tag.tagId,
        location: location,
        action: action,
        timestamp: DateTime.now(),
      );
      final updatedData = List<DataEntity>.from(state.record.data)..add(newData);
      emit(state.copyWith(
        deck: state.deck.copyWith(cards: updatedCards),
        record: state.record.copyWith(data: updatedData),
      ));
    } catch (e) {
      emit(state.copyWith(isProcessing: false));
    }
  }

  void _moveCardToTop(TagEntity tag) {
    final updatedCards = Map.of(state.deck.cards);
    final cardEntry = updatedCards.entries.firstWhere(
      (entry) => entry.key.cardId == tag.cardId,
      orElse: () => throw Exception("Card not found in deck"),
    );
    updatedCards.remove(cardEntry.key);
    final reorderedCards = {
      cardEntry.key: cardEntry.value,
      ...updatedCards,
    };
    emit(state.copyWith(
      deck: state.deck.copyWith(cards: reorderedCards),
    ));
  }
}
