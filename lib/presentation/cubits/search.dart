import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/usecases/cards_management.dart';

class SearchState {
  final List<CardEntity> allCards;
  final List<CardEntity> cards;
  final String? errorMessage;
  final bool isLoading;

  SearchState({
    this.allCards = const [],
    this.cards = const [],
    this.errorMessage,
    this.isLoading = false,
  });

  SearchState copyWith({
    List<CardEntity>? allCards,
    List<CardEntity>? cards,
    String? errorMessage,
    bool? isLoading,
  }) {
    return SearchState(
      allCards: allCards ?? this.allCards,
      cards: cards ?? this.cards,
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
      safeEmit(state.copyWith(allCards: syncedCards, cards: syncedCards, isLoading: false));
    } catch (e) {
      safeEmit(state.copyWith(errorMessage: 'Failed to sync cards: $e', isLoading: false));
    }
  }

  void searchCards(String query) {
    if (isClosed) return;
    safeEmit(state.copyWith(
      cards: state.allCards
          .where((card) => card.name.toLowerCase().contains(query.toLowerCase()))
          .toList(),
    ));
  }

  void clearSearch() {
    if (isClosed) return;
    safeEmit(state.copyWith(cards: state.allCards));
  }
}
