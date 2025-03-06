import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/core/services/locator.dart';
import 'package:nfc_project/core/storage/shared_preferences.dart';

class AppState extends Equatable {
  final int currentPageIndex;
  final String? selectedGame;

  const AppState({
    this.currentPageIndex = 0,
    this.selectedGame,
  });

  AppState copyWith({
    int? currentPageIndex,
    String? selectedGame,
  }) {
    return AppState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      selectedGame: selectedGame ?? this.selectedGame,
    );
  }

  @override
  List<Object?> get props => [currentPageIndex, selectedGame];
}

class AppCubit extends Cubit<AppState> {
  final SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();

  AppCubit() : super(AppState(selectedGame: locator<SharedPreferencesService>().getSelectedGame()));

  void safeEmit(AppState newState) {
    if (!isClosed && state != newState) {
      emit(newState);
    }
  }

  String getRouteForIndex(int index) {
    return const {
      0: AppRoutes.myDecks,
      1: AppRoutes.read,
      2: AppRoutes.setting,
    }[index] ?? AppRoutes.index;
  }

  void updatePageIndex(int index) => safeEmit(state.copyWith(currentPageIndex: index));

  Future<void> updateSelectedGame(String game) async {
    try {
      await _sharedPreferencesService.saveSelectedGame(game);
      safeEmit(state.copyWith(selectedGame: game));
    } catch (e) {
      print('Error updating selected game: $e');
    }
  }
}
