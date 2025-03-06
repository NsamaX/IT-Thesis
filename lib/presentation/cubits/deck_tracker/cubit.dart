import 'dart:ui';

import 'package:equatable/equatable.dart';
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
class DeckTrackCubit extends Cubit<DeckTrackState> {
  final SaveRecordUseCase saveRecordUseCase;
  final RemoveRecordUseCase recordUseCase;
  final FetchRecordUseCase fetchRecordUseCase;

  DeckTrackCubit(
    DeckEntity deck, {
    required this.saveRecordUseCase,
    required this.recordUseCase,
    required this.fetchRecordUseCase,
  }) : super(DeckTrackState(
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
  void safeEmit(DeckTrackState newState) {
    if (!isClosed && state != newState) {
      emit(newState);
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
  void showDialog() => safeEmit(state.copyWith(isDialogShown: true));

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
  void toggleAdvanceMode() => safeEmit(state.copyWith(isAdvanceModeEnabled: !state.isAdvanceModeEnabled));

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
  void toggleAnalyzeMode() => safeEmit(state.copyWith(isAnalyzeModeEnabled: !state.isAnalyzeModeEnabled));

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
  void toggleReset() {
    safeEmit(state.copyWith(
      isProcessing: false,
      isDialogShown: true,
      currentDeck: state.initialDeck,
      record: RecordEntity(
        recordId: DateTime.now().toIso8601String(),
        createdAt: DateTime.now(),
        data: [],
      ),
      history: [],
      cardColors: {},
    ));
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
  Future<void> toggleSaveRecord() async {
    if (state.record.data.isEmpty) return;
    try {
      await saveRecordUseCase.call(state.record);
      await fetchRecord();
      toggleReset();
    } catch (e) {
      print('Error saving record: $e');
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
  Future<void> toggleRemoveRecord(String recordId) async {
    try {
      await recordUseCase.call(recordId);
    } catch (e) {
      print('Error removing record: $e');
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
  Future<void> fetchRecordById(String recordId) async {
    try {
      final record = state.records.firstWhere(
        (record) => record.recordId == recordId,
        orElse: () => RecordEntity(
          recordId: recordId,
          createdAt: DateTime.now(),
          data: [],
        ),
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

      safeEmit(state.copyWith(record: record, history: history));
    } catch (e) {
      print('Error fetching record by ID: $e');
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
  Future<void> fetchRecord() async {
    try {
      final records = await fetchRecordUseCase.call();
      safeEmit(state.copyWith(records: records.reversed.toList()));
    } catch (e) {
      print('Error fetching records: $e');
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
  void readTag(TagEntity tag) {
    if (state.isProcessing) return;
    safeEmit(state.copyWith(isProcessing: true));

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
        updateCardCount(tag, Action.returnToDeck, "in", 1, state, emit);
      } else if (existingData.action == Action.returnToDeck) {
        updateCardCount(tag, Action.draw, "out", -1, state, emit);
      } else {
        updateCardCount(tag, Action.draw, "out", -1, state, emit);
      }

      moveCardToTop(tag, state, emit);
      safeEmit(state.copyWith(isProcessing: false, history: updatedHistory));
    } catch (e) {
      safeEmit(state.copyWith(isProcessing: false));
      print('Error reading tag: $e');
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
    final result = <Map<String, dynamic>>[];
    final drawCounts = <String, int>{};
    final returnCounts = <String, int>{};
    final cardNames = <String, String>{};

    for (final data in state.record.data) {
      final tagId = data.tagId;
      cardNames[tagId] = data.name;

      if (data.action == Action.draw) {
        drawCounts[tagId] = (drawCounts[tagId] ?? 0) + 1;
      } else if (data.action == Action.returnToDeck) {
        returnCounts[tagId] = (returnCounts[tagId] ?? 0) + 1;
      }
    }

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
    safeEmit(state.copyWith(cardColors: updatedColors));
  }
}
