import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/data.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import 'package:nfc_project/domain/entities/record.dart';
import 'package:nfc_project/domain/entities/tag.dart';

class TrackState {
  final DeckEntity initialDeck;
  final DeckEntity currentDeck;
  final RecordEntity record;
  final List<CardEntity> history;
  final Map<String, Color> cardColors;
  final bool isDialogShown;
  final bool isProcessing;
  final bool isAdvanceModeEnabled;
  final bool isAnalyzeModeEnabled;

  TrackState({
    required this.initialDeck,
    required this.currentDeck,
    required this.record,
    this.history = const [],
    this.cardColors = const {},
    this.isDialogShown = false,
    this.isProcessing = false,
    this.isAdvanceModeEnabled = false,
    this.isAnalyzeModeEnabled = false,
  });

  TrackState copyWith({
    DeckEntity? initialDeck,
    DeckEntity? deck,
    RecordEntity? record,
    List<CardEntity>? history,
    Map<String, Color>? cardColors,
    bool? isDialogShown,
    bool? isProcessing,
    bool? isAdvanceModeEnabled,
    bool? isAnalyzeModeEnabled,
  }) => TrackState(
    initialDeck: initialDeck ?? this.initialDeck,
    currentDeck: deck ?? this.currentDeck,
    record: record ?? this.record,
    history: history ?? this.history,
    cardColors: cardColors ?? this.cardColors,
    isDialogShown: isDialogShown ?? this.isDialogShown,
    isProcessing: isProcessing ?? this.isProcessing,
    isAdvanceModeEnabled: isAdvanceModeEnabled ?? this.isAdvanceModeEnabled,
    isAnalyzeModeEnabled: isAnalyzeModeEnabled ?? this.isAnalyzeModeEnabled,
  );
}

class TrackCubit extends Cubit<TrackState> {
  TrackCubit(DeckEntity deck)
      : super(TrackState(
          initialDeck: deck,
          currentDeck: deck.copyWith(cards: Map.of(deck.cards)),
          record: RecordEntity(
            recordId: DateTime.now().toIso8601String(),
            createdAt: DateTime.now(),
            data: [],
          ),
        ));

  //--------------------------------- toggle ---------------------------------//
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
    cardColors: {},
  ));

  //---------------------------- update card data ----------------------------//
  void readTag(TagEntity tag) {
    if (state.isProcessing) return;
    emit(state.copyWith(isProcessing: true));
    try {
      final matchingCard = state.currentDeck.cards.keys.firstWhere(
        (card) => card.cardId == tag.cardId,
        orElse: () => throw Exception("Card not found in deck"),
      );
      final updatedHistory = [...state.history, matchingCard];
      final existingData = state.record.data.lastWhere(
        (data) => data.tagId == tag.tagId,
        orElse: () => DataEntity(
          tagId: tag.tagId,
          name: matchingCard.name,
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
    final cardEntry = state.currentDeck.cards.entries.firstWhere(
      (entry) => entry.key.cardId == tag.cardId,
      orElse: () => throw Exception("Card not found in deck"),
    );
    final currentCount = cardEntry.value;
    if ((currentCount + delta) < 0) return;
    final updatedCards = {...state.currentDeck.cards};
    updatedCards[cardEntry.key] = (currentCount + delta).clamp(0, double.infinity).toInt();
    final updatedData = [
      ...state.record.data,
      DataEntity(
        tagId: tag.tagId,
        name: cardEntry.key.name,
        location: location,
        action: action,
        timestamp: DateTime.now(),
      ),
    ];
    emit(state.copyWith(
      deck: state.currentDeck.copyWith(cards: updatedCards),
      record: state.record.copyWith(data: updatedData),
    ));
  }

  void _moveCardToTop(TagEntity tag) {
    final updatedCards = {...state.currentDeck.cards};
    final cardEntry = updatedCards.entries.firstWhere(
      (entry) => entry.key.cardId == tag.cardId,
      orElse: () => throw Exception("Card not found in deck"),
    );
    updatedCards.remove(cardEntry.key);
    emit(state.copyWith(
      deck: state.currentDeck.copyWith(cards: {cardEntry.key: cardEntry.value, ...updatedCards}),
    ));
  }

  //-------------------------------- get data --------------------------------//
  List<Map<String, dynamic>> calculateDrawAndReturnCounts() {
    final cardNames = <String, String>{};
    final drawCounts = <String, int>{};
    final returnCounts = <String, int>{};
    for (final data in state.record.data) {
      final tagId = data.tagId;
      cardNames[tagId] = data.name;
      if (data.action == Action.draw) {
        drawCounts[tagId] = (drawCounts[tagId] ?? 0) + 1;
      } else if (data.action == Action.returnToDeck) {
        returnCounts[tagId] = (returnCounts[tagId] ?? 0) + 1;
      }
    }
    final result = <Map<String, dynamic>>[];
    for (final tagId in cardNames.keys) {
      result.add({
        "CardName": cardNames[tagId] ?? "Unknown",
        "draw": drawCounts[tagId] ?? 0,
        "return": returnCounts[tagId] ?? 0,
      });
    }
    return result;
  }

  void changeCardColor(String cardId, Color color) {
    final updatedColors = Map<String, Color>.from(state.cardColors);
    updatedColors[cardId] = color;
    emit(state.copyWith(cardColors: updatedColors));
  }
}
