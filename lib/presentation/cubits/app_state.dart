import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/routes/routes.dart';

/// คลาสสำหรับจัดการสถานะแอป (AppState)
class AppState {
  /// ดัชนีหน้าปัจจุบันใน Navigation
  final int currentPageIndex;

  /// เกมที่ถูกเลือกในปัจจุบัน
  final String selectedGame;

  /// สร้างออบเจ็กต์ AppState
  AppState({
    required this.currentPageIndex,
    required this.selectedGame,
  });

  /// สร้างออบเจ็กต์ใหม่โดยการคัดลอกค่าจากออบเจ็กต์เดิม
  /// - สามารถปรับเปลี่ยนค่า [currentPageIndex] หรือ [selectedGame] ได้
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

/// Cubit สำหรับจัดการสถานะแอป (AppState) ในการใช้งาน BLoC
class AppStateCubit extends Cubit<AppState> {
  AppStateCubit() : super(AppState(currentPageIndex: 0, selectedGame: 'vanguard'));

  //------------------------- การจัดการเส้นทาง (Routes) -------------------------//
  /// แปลงดัชนีหน้าเป็นชื่อเส้นทางใน Navigation
  /// - [index]: ดัชนีหน้าใน Navigation
  /// - คืนค่าชื่อเส้นทางที่สัมพันธ์กับดัชนี
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

  //----------------------------- การอัปเดตดัชนีหน้า -----------------------------//
  /// อัปเดตดัชนีหน้าปัจจุบันในสถานะแอป
  /// - [index]: ดัชนีหน้าที่ต้องการอัปเดต
  void updatePageIndex(int index) => emit(state.copyWith(currentPageIndex: index));

  //----------------------------- การอัปเดตเกมที่เลือก ----------------------------//
  /// อัปเดตชื่อเกมที่เลือกในสถานะแอป
  /// - [game]: ชื่อเกมใหม่ที่ต้องการอัปเดต
  void updateSelectedGame(String game) => emit(state.copyWith(selectedGame: game));
}
