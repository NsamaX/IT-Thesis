import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/usecases/card.dart';

class SearchState extends Equatable {
  final List<CardEntity> cards;
  final List<CardEntity> searchedCards;
  final String? errorMessage;
  final bool isLoading;

  const SearchState({
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
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [cards, searchedCards, errorMessage, isLoading];
}

class SearchCubit extends Cubit<SearchState> {
  final SyncCardsUseCase syncCardsUseCase;

  SearchCubit(this.syncCardsUseCase) : super(const SearchState());

  void safeEmit(SearchState newState) {
    if (!isClosed && state != newState) {
      emit(newState);
    }
  }

  Future<void> syncCards(String game) async {
    if (state.isLoading || isClosed) return;
    safeEmit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final syncedCards = await syncCardsUseCase(game);
      safeEmit(state.copyWith(
        cards: syncedCards,
        searchedCards: syncedCards,
        isLoading: false,
      ));
    } catch (e) {
      safeEmit(state.copyWith(
        errorMessage: 'Failed to sync cards: $e',
        isLoading: false,
      ));
    }
  }

  void searchCards(String query) {
    if (isClosed) return;

    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      clearSearch();
      return;
    }

    final filteredCards = state.cards
        .where((card) => card.name.toLowerCase().contains(trimmedQuery.toLowerCase()))
        .toList();

    safeEmit(state.copyWith(searchedCards: filteredCards));
  }

  void clearSearch() => safeEmit(state.copyWith(searchedCards: state.cards));
}
