import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/usecases/sync_cards.dart';

abstract class SearchEvent {}

class SyncCardsEvent extends SearchEvent {
  final String game;
  SyncCardsEvent(this.game);
}

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<CardEntity> cards;
  SearchLoaded({required this.cards});
}

class SearchError extends SearchState {
  final String message;
  SearchError({required this.message});
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SyncCardsUseCase syncCardsUseCase;

  SearchBloc(this.syncCardsUseCase) : super(SearchInitial()) {
    on<SyncCardsEvent>(_onSyncCardsEvent);
  }

  Future<void> _onSyncCardsEvent(SyncCardsEvent event, Emitter<SearchState> emit) async {
    if (state is SearchLoading || state is SearchLoaded) return;
    emit(SearchLoading());
    try {
      final syncedCards = await syncCardsUseCase.call(event.game);
      emit(SearchLoaded(cards: syncedCards));
    } catch (e) {
      emit(SearchError(message: 'Failed to sync cards: $e'));
    }
  }
}
