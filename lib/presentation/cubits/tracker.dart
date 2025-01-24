import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/data.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import 'package:nfc_project/domain/entities/record.dart';
import 'package:nfc_project/domain/entities/tag.dart';

class TrackState {
  final DeckEntity deck;
  final RecordEntity record;
  final List<CardEntity> history;
  final bool isDialogShown;
  final bool isProcessing;
  final bool isAdvanceModeEnabled;
  final bool isAnalyzeModeEnabled;

  TrackState({
    required this.deck,
    required this.record,
    this.history = const [],
    this.isDialogShown = false,
    this.isProcessing = false,
    this.isAdvanceModeEnabled = false,
    this.isAnalyzeModeEnabled = false,
  });

  TrackState copyWith({
    DeckEntity? deck,
    RecordEntity? record,
    List<CardEntity>? history,
    bool? isDialogShown,
    bool? isProcessing,
    bool? isAdvanceModeEnabled,
    bool? isAnalyzeModeEnabled,
  }) => TrackState(
    deck: deck ?? this.deck,
    record: record ?? this.record,
    history: history ?? this.history,
    isDialogShown: isDialogShown ?? this.isDialogShown,
    isProcessing: isProcessing ?? this.isProcessing,
    isAdvanceModeEnabled: isAdvanceModeEnabled ?? this.isAdvanceModeEnabled,
    isAnalyzeModeEnabled: isAnalyzeModeEnabled ?? this.isAnalyzeModeEnabled,
  );
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
        ));

  void showDialog() => emit(state.copyWith(isDialogShown: true));

  void toggleAdvanceMode() => emit(state.copyWith(isAdvanceModeEnabled: !state.isAdvanceModeEnabled));

  void toggleAnalyzeMode() => emit(state.copyWith(isAnalyzeModeEnabled: !state.isAnalyzeModeEnabled));

  void toggleReset(DeckEntity deck) => emit(state.copyWith(
    isProcessing: false,
    isDialogShown: true,
    deck: deck.copyWith(cards: Map.of(deck.cards)),
    record: RecordEntity(
      recordId: DateTime.now().toIso8601String(),
      createdAt: DateTime.now(),
      data: [],
    ),
    history: [],
  ));

  void readTag(TagEntity tag) {
    if (state.isProcessing) return;
    emit(state.copyWith(isProcessing: true));
    try {
      final matchingCard = state.deck.cards.keys.firstWhere(
        (card) => card.cardId == tag.cardId,
        orElse: () => throw Exception("Card not found in deck"),
      );
      final updatedHistory = [...state.history, matchingCard];
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
      } else {
        _updateCardCount(tag, Action.draw, "out", -1);
      }
      _moveCardToTop(tag);
      emit(state.copyWith(isProcessing: false, history: updatedHistory));
    } catch (e) {
      emit(state.copyWith(isProcessing: false));
    }
  }

  void _updateCardCount(TagEntity tag, Action action, String location, int delta) {
    final cardEntry = state.deck.cards.entries.firstWhere(
      (entry) => entry.key.cardId == tag.cardId,
      orElse: () => throw Exception("Card not found in deck"),
    );
    final currentCount = cardEntry.value;
    if ((currentCount + delta) < 0) return;
    final updatedCards = {...state.deck.cards};
    updatedCards[cardEntry.key] = (currentCount + delta).clamp(0, double.infinity).toInt();
    final updatedData = [
      ...state.record.data,
      DataEntity(
        tagId: tag.tagId,
        location: location,
        action: action,
        timestamp: DateTime.now(),
      ),
    ];
    emit(state.copyWith(
      deck: state.deck.copyWith(cards: updatedCards),
      record: state.record.copyWith(data: updatedData),
    ));
  }

  void _moveCardToTop(TagEntity tag) {
    final updatedCards = {...state.deck.cards};
    final cardEntry = updatedCards.entries.firstWhere(
      (entry) => entry.key.cardId == tag.cardId,
      orElse: () => throw Exception("Card not found in deck"),
    );
    updatedCards.remove(cardEntry.key);
    emit(state.copyWith(
      deck: state.deck.copyWith(cards: {cardEntry.key: cardEntry.value, ...updatedCards}),
    ));
  }
}
