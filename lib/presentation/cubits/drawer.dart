import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerCubit extends Cubit<Map<String, bool>> {
  DrawerCubit() : super({'history': false, 'feature': false});

  void toggleDrawer(String drawerName) {
    emit({
      ...state,
      drawerName: !(state[drawerName] ?? false),
    });
  }

  void closeDrawer() => emit(state.map((key, _) => MapEntry(key, false)));

  bool isDrawerVisible(String drawerName) => state[drawerName] ?? false;
}
