import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerState extends Equatable {
  final Map<String, bool> drawers;

  const DrawerState({this.drawers = const {'history': false, 'feature': false}});

  DrawerState copyWith({Map<String, bool>? drawers}) {
    return DrawerState(drawers: drawers ?? this.drawers);
  }

  bool isDrawerVisible(String drawerName) => drawers[drawerName] ?? false;

  @override
  List<Object> get props => [drawers];
}

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(const DrawerState());

  void toggleDrawer(String drawerName) {
    final updatedDrawers = Map<String, bool>.from(state.drawers);
    updatedDrawers[drawerName] = !(updatedDrawers[drawerName] ?? false);
    emit(state.copyWith(drawers: updatedDrawers));
  }

  void closeDrawer() {
    emit(state.copyWith(
      drawers: state.drawers.map((key, _) => MapEntry(key, false)),
    ));
  }
}
