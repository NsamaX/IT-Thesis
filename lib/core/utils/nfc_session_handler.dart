import 'package:flutter/widgets.dart';
import 'package:nfc_project/presentation/cubits/NFC.dart';

/// ตัวจัดการเซสชัน NFC สำหรับจัดการการทำงานเมื่อแอปเปลี่ยนสถานะ
class NFCSessionHandler with WidgetsBindingObserver {
  /// อินสแตนซ์ของ NFCCubit สำหรับควบคุมสถานะ NFC
  final NFCCubit nfcCubit;

  /// สร้างตัวจัดการ NFC Session ด้วย NFCCubit
  NFCSessionHandler(this.nfcCubit);

  //----------------------------- การเริ่มต้นและกำจัด -----------------------------//
  /// ลงทะเบียน `WidgetsBindingObserver` เพื่อฟังสถานะ Lifecycle ของแอป
  void initNFCSessionHandler() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// ลบการลงทะเบียน `WidgetsBindingObserver` และหยุดเซสชัน NFC
  void disposeNFCSessionHandler() {
    WidgetsBinding.instance.removeObserver(this);
    _stopNFCSession('Page disposed');
  }

  //------------------------- การจัดการสถานะ Lifecycle -------------------------//
  /// เรียกใช้เมื่อสถานะ Lifecycle ของแอปเปลี่ยนแปลง
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    handleAppLifecycleState(state);
  }

  /// จัดการสถานะ Lifecycle ของแอป
  /// - หยุดเซสชัน NFC เมื่อแอปถูกย่อหน้าต่างหรือหยุดทำงาน
  void handleAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _stopNFCSession('App moved to background or detached: $state');
    }
  }

  //----------------------------- การหยุดเซสชัน NFC ----------------------------//
  /// หยุดเซสชัน NFC และแสดงเหตุผลใน Debug Log
  /// - [reason]: เหตุผลที่หยุดเซสชัน
  void _stopNFCSession(String reason) {
    if (!nfcCubit.isClosed && nfcCubit.state.isNFCEnabled) {
      nfcCubit.stopSession(reason: reason);
      debugPrint('NFC session stopped: $reason');
    }
  }
}
