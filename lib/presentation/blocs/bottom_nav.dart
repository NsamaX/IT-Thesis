import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/route.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit(int initialIndex) : super(initialIndex);

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
}
