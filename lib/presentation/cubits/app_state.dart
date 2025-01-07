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

class AppStateCubit extends Cubit<AppState> {
  AppStateCubit() : super(AppState(currentPageIndex: 0, selectedGame: 'vanguard'));

  String getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return AppRoutes.my_decks;
      case 1:
        return AppRoutes.scan;
      case 2:
        return AppRoutes.setting;
      default:
        return AppRoutes.index;
    }
  }

  void updatePageIndex(int index) => emit(state.copyWith(currentPageIndex: index));

  void updateSelectedGame(String game) => emit(state.copyWith(selectedGame: game));
}
