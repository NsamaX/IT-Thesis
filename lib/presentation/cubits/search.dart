import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/usecases/cards_management.dart';

class SearchState {
  final List<CardEntity> cards;
  final List<CardEntity> searchedCards;
  final String? errorMessage;
  final bool isLoading;

  SearchState({
    this.cards = const [],
    this.searchedCards = const [],
    this.errorMessage,
    this.isLoading = false,
  });

  SearchState copyWith({
    List<CardEntity>? cards,
    List<CardEntity>? searchedCards,
    String? errorMessage,
    bool? isLoading,
  }) {
    return SearchState(
      cards: cards ?? this.cards,
      searchedCards: searchedCards ?? this.searchedCards,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SearchCubit extends Cubit<SearchState> {
  final SyncCardsUseCase syncCardsUseCase;

  SearchCubit(this.syncCardsUseCase) : super(SearchState());

  void safeEmit(SearchState newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> syncCards(String game) async {
    if (state.isLoading || isClosed) return;
    safeEmit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final syncedCards = await syncCardsUseCase(game);
      safeEmit(state.copyWith(cards: syncedCards, searchedCards: syncedCards, isLoading: false));
    } catch (e) {
      safeEmit(state.copyWith(errorMessage: 'Failed to sync cards: $e', isLoading: false));
    }
  }

  void searchCards(String query) {
    if (isClosed) return;
    safeEmit(state.copyWith(
      searchedCards: state.cards
          .where((card) => card.name.toLowerCase().contains(query.toLowerCase()))
          .toList(),
    ));
  }

  void clearSearch() {
    if (isClosed) return;
    safeEmit(state.copyWith(searchedCards: state.cards));
  }
}
