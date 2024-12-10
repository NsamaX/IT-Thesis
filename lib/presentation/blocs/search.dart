import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/usecases/fetch_cards.dart';

abstract class SearchEvent {}

class FetchPageEvent extends SearchEvent {
  final int page;
  FetchPageEvent(this.page);
}

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<CardEntity> cards;
  final bool hasNextPage;
  SearchLoaded({required this.cards, required this.hasNextPage});
}

class SearchError extends SearchState {
  final String message;
  SearchError({required this.message});
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FetchCardsPageUseCase fetchCardsPageUseCase;
  bool isLoading = false;
  bool hasNextPage = true;
  int currentPage = 0;
  List<CardEntity> cards = [];

  SearchBloc(this.fetchCardsPageUseCase) : super(SearchInitial()) {
    on<FetchPageEvent>(_onFetchPageEvent);
  }

  Future<void> _onFetchPageEvent(FetchPageEvent event, Emitter<SearchState> emit) async {
    if (isLoading || !hasNextPage) return;
    isLoading = true;

    try {
      final newCards = await fetchCardsPageUseCase(event.page);
      if (newCards.isEmpty) {
        hasNextPage = false;
      } else {
        currentPage = event.page;
        cards.addAll(newCards);
        emit(SearchLoaded(cards: cards, hasNextPage: hasNextPage));
      }
    } catch (e) {
      emit(SearchError(message: e.toString()));
    } finally {
      isLoading = false;
    }
  }
}
