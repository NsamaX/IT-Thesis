import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/tag.dart';
import 'package:nfc_project/domain/usecases/cards_management.dart';

class ScanCubitState {
  final List<CardEntity>? cards;
  final bool isLoading;
  final String? currentGame, error;

  ScanCubitState({
    this.cards,
    this.isLoading = false,
    this.currentGame,
    this.error,
  });

  ScanCubitState copyWith({
    List<CardEntity>? cards,
    bool? isLoading,
    String? currentGame, error,
  }) {
    return ScanCubitState(
      cards: cards ?? this.cards,
      isLoading: isLoading ?? this.isLoading,
      currentGame: currentGame ?? this.currentGame,
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
}
