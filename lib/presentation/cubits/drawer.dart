import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerCubit extends Cubit<Map<String, bool>> {
  DrawerCubit() : super({'history': false, 'feature': false});

  void toggleDrawer(String drawerName) {
    final newState = Map<String, bool>.from(state);
    newState[drawerName] = !(newState[drawerName] ?? false);
    emit(newState);
  }

  void closeDrawer() => emit(state.map((key, value) => MapEntry(key, false)));

  bool isDrawerVisible(String drawerName) => state[drawerName] ?? false;
}
