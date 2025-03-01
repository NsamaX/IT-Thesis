import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/core/services/locator.dart';
import 'package:nfc_project/core/storage/shared_preferences.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class AppState {
  final int currentPageIndex;
  final String? selectedGame;

  AppState({
    required this.currentPageIndex,
    required this.selectedGame,
  });

  AppState copyWith({
    int? currentPageIndex,
    String? selectedGame,
  }) => AppState(
    currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    selectedGame: selectedGame ?? this.selectedGame,
  );
}

class AppCubit extends Cubit<AppState> {
  final SharedPreferencesService _sharedPreferencesService = locator<SharedPreferencesService>();

  AppCubit() : super(AppState(
    currentPageIndex: 0,
    selectedGame: locator<SharedPreferencesService>().getSelectedGame(),
  ));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  String getRouteForIndex(int index) => const {
    0: AppRoutes.myDecks,
    1: AppRoutes.read,
    2: AppRoutes.setting,
  }[index] ?? AppRoutes.index;

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void updatePageIndex(int index) => emit(state.copyWith(currentPageIndex: index));

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> updateSelectedGame(String game) async {
    await _sharedPreferencesService.saveSelectedGame(game);
    emit(state.copyWith(selectedGame: game));
  }
}
