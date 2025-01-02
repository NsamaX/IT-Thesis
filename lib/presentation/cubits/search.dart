import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/usecases/sync_cards.dart';

class SearchState {
  final List<CardEntity> allCards;
  final List<CardEntity> cards;
  final bool isLoading;
  final String? errorMessage;

  SearchState({
    this.allCards = const [],
    this.cards = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  SearchState copyWith({
    List<CardEntity>? allCards,
    List<CardEntity>? cards,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SearchState(
      allCards: allCards ?? this.allCards,
      cards: cards ?? this.cards,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class SearchCubit extends Cubit<SearchState> {
  final SyncCardsUseCase syncCardsUseCase;

  SearchCubit(this.syncCardsUseCase) : super(SearchState());

  Future<void> syncCards(String game) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final syncedCards = await syncCardsUseCase.call(game);
      emit(state.copyWith(
        allCards: syncedCards,
        cards: syncedCards,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to sync cards: $e',
        isLoading: false,
      ));
    }
  }

  void searchCards(String query) {
    final filteredCards = state.allCards
        .where((card) => card.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(state.copyWith(cards: filteredCards));
  }

  void clearSearch() => emit(state.copyWith(cards: state.allCards));
}
