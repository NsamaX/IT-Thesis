import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/tag.dart';
import 'package:nfc_project/domain/usecases/card.dart';

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
class ReaderCubitState extends Equatable {
  final List<CardEntity> cards;
  final String? currentGame;
  final bool isLoading;
  final String? errorMessage;

  const ReaderCubitState({
    this.cards = const [],
    this.currentGame,
    this.isLoading = false,
    this.errorMessage,
  });

  ReaderCubitState copyWith({
    List<CardEntity>? cards,
    String? currentGame,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReaderCubitState(
      cards: cards ?? this.cards,
      currentGame: currentGame ?? this.currentGame,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [cards, currentGame, isLoading, errorMessage];
}

class ReaderCubit extends Cubit<ReaderCubitState> {
  final FetchCardByIdUseCase fetchCardByIdUseCase;

  ReaderCubit({required this.fetchCardByIdUseCase}) : super(const ReaderCubitState());

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
  void safeEmit(ReaderCubitState newState) {
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
  Future<void> fetchCardById(TagEntity tag) async {
    safeEmit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final card = await fetchCardByIdUseCase(tag.game, tag.cardId);
      final updatedCards = List<CardEntity>.from(state.cards)..add(card);

      safeEmit(state.copyWith(
        cards: updatedCards,
        currentGame: tag.game,
        isLoading: false,
      ));
    } catch (e) {
      safeEmit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch card: $e',
      ));
    }
  }
}
