import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/data.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import 'package:nfc_project/domain/entities/record.dart';
import 'package:nfc_project/domain/entities/tag.dart';
import 'package:nfc_project/domain/usecases/record.dart';

part 'helper.dart';
part 'state.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class TrackCubit extends Cubit<TrackState> {
  final SaveRecordUseCase saveRecordUseCase;
  final RemoveRecordUseCase recordUseCase;
  final FetchRecordUseCase fetchRecordUseCase;

  TrackCubit(
    DeckEntity deck, {
    required this.saveRecordUseCase,
    required this.recordUseCase,
    required this.fetchRecordUseCase,
  }) : super(TrackState(
          initialDeck: deck,
          currentDeck: deck.copyWith(cards: Map.of(deck.cards)),
          record: RecordEntity(
            recordId: DateTime.now().toIso8601String(),
            createdAt: DateTime.now(),
            data: [],
          ),
        ));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void showDialog() => emit(state.copyWith(isDialogShown: true));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void toggleAdvanceMode() => emit(state.copyWith(isAdvanceModeEnabled: !state.isAdvanceModeEnabled));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void toggleAnalyzeMode() => emit(state.copyWith(isAnalyzeModeEnabled: !state.isAnalyzeModeEnabled));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void toggleReset() => emit(state.copyWith(
    isProcessing: false,
    isDialogShown: true,
    deck: state.initialDeck,
    record: RecordEntity(
      recordId: DateTime.now().toIso8601String(),
      createdAt: DateTime.now(),
      data: [],
    ),
    history: [],
    cardColors: {},
  ));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> toggleSaveRecord() async {
    if (state.record.data.isEmpty) return;
    await saveRecordUseCase.call(state.record);
    fetchRecord();
    toggleReset();
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> toggleRemoveRecord(String recordId) async {
    await recordUseCase.call(recordId);
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> fetchRecordById(String recordId) async {
    final record = state.records.firstWhere(
      (record) => record.recordId == recordId,
      orElse: () => throw Exception("Record not found"),
    );
    final history = record.data.map((data) {
      final card = state.initialDeck.cards.keys.firstWhere(
        (card) => card.cardId == data.tagId,
        orElse: () => CardEntity(
          cardId: data.tagId,
          game: '',
          name: data.name,
          description: '',
        ),
      );
      return card.copyWith(description: '');
    }).toList();
    emit(state.copyWith(record: record, history: history));
  }

  Future<void> fetchRecord() async {
    final records = await fetchRecordUseCase.call();
    emit(state.copyWith(records: records.reversed.toList()));
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
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
          imageUrl: matchingCard.imageUrl ?? '',
          location: "deck",
          action: Action.unknown,
          timestamp: DateTime.now(),
        ),
      );
      if (existingData.action == Action.draw) {
        updateCardCount(tag, Action.draw, "out", -1, state, emit);
      } else {
        updateCardCount(tag, Action.draw, "out", -1, state, emit);
      }
      moveCardToTop(tag, state, emit);
      emit(state.copyWith(isProcessing: false, history: updatedHistory));
    } catch (e) {
      emit(state.copyWith(isProcessing: false));
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
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

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void changeCardColor(String cardId, Color color) {
    final updatedColors = Map<String, Color>.from(state.cardColors);
    updatedColors[cardId] = color;
    emit(state.copyWith(cardColors: updatedColors));
  }
}
