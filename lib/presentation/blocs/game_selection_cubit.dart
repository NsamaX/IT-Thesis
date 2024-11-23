import 'package:flutter_bloc/flutter_bloc.dart';

class GameSelectionCubit extends Cubit<String> {
  GameSelectionCubit() : super('vanguard');

  void selectGame(String game) {
    emit(game);
  }
}
