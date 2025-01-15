import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/routes/routes.dart';

class AppState {
  final int currentPageIndex;
  final String selectedGame;

  AppState({
    required this.currentPageIndex,
    required this.selectedGame,
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
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState(currentPageIndex: 0, selectedGame: 'vanguard'));

  String getRouteForIndex(int index) {
    const routes = {
      0: AppRoutes.myDecks,
      1: AppRoutes.read,
      2: AppRoutes.setting,
    };
    return routes[index] ?? AppRoutes.index;
  }

  void updatePageIndex(int index) => emit(state.copyWith(currentPageIndex: index));

  void updateSelectedGame(String game) => emit(state.copyWith(selectedGame: game));
}
