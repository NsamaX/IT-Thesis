import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/route.dart';

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
  AppStateCubit() : super(AppState(currentPageIndex: 1, selectedGame: 'vanguard'));

  String getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return AppRoutes.myDeck;
      case 1:
        return AppRoutes.read;
      case 2:
        return AppRoutes.setting;
      default:
        return AppRoutes.index;
    }
  }

  void updatePageIndex(int index) {
    emit(state.copyWith(currentPageIndex: index));
  }

  void updateSelectedGame(String game) {
    emit(state.copyWith(selectedGame: game));
  }
}
