import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/tag.dart';
import 'package:nfc_project/domain/usecases/@export.dart';

class ScanCubitState {
  final List<CardEntity>? cards;
  final String? currentGame;
  final bool isLoading;
  final String? error;

  ScanCubitState({
    this.cards,
    this.currentGame,
    this.isLoading = false,
    this.error,
  });

  ScanCubitState copyWith({
    List<CardEntity>? cards,
    String? currentGame,
    bool? isLoading,
    String? error,
  }) {
    return ScanCubitState(
      cards: cards ?? this.cards,
      currentGame: currentGame ?? this.currentGame,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ScanCubit extends Cubit<ScanCubitState> {
  final FetchCardByIdUseCase fetchCardByIdUseCase;

  ScanCubit({required this.fetchCardByIdUseCase}) : super(ScanCubitState());

  Future<void> fetchCardById(TagEntity tag) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final card = await fetchCardByIdUseCase(tag.game, tag.cardId);
      emit(state.copyWith(
        cards: [...?state.cards, card],
        currentGame: tag.game,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void resetCards() {
    emit(state.copyWith(cards: [], currentGame: null, error: null));
  }
}
