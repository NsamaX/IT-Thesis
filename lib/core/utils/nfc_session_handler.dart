import 'package:flutter/widgets.dart';
import 'package:nfc_project/presentation/cubits/NFC.dart';

class NFCSessionHandler with WidgetsBindingObserver {
  final NFCCubit nfcCubit;

  NFCSessionHandler(this.nfcCubit);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน initNFCSessionHandler
   |
   |  วัตถุประสงค์:
   |      ลงทะเบียน observer เพื่อฟัง event ของ AppLifecycleState
   *--------------------------------------------------------------------------*/
  void initNFCSessionHandler() {
    WidgetsBinding.instance.addObserver(this);
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน disposeNFCSessionHandler
   |
   |  วัตถุประสงค์:
   |      ยกเลิก observer และปิด session NFC เมื่อหน้านี้ถูก dispose
   *--------------------------------------------------------------------------*/
  void disposeNFCSessionHandler() {
    WidgetsBinding.instance.removeObserver(this);
    _stopNFCSession('Page disposed');
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน didChangeAppLifecycleState
   |
   |  วัตถุประสงค์:
   |      ตรวจสอบสถานะของแอป และปิด NFC หากแอปถูกพักหรือปิด
   |
   |  พารามิเตอร์:
   |      state (IN) -- สถานะของแอปในปัจจุบัน
   *--------------------------------------------------------------------------*/
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        _stopNFCSession('App moved to background or detached: $state');
        break;
      default:
        break;
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _stopNFCSession
   |
   |  วัตถุประสงค์:
   |      ปิด session NFC ถ้าหาก NFC กำลังทำงานอยู่
   |
   |  พารามิเตอร์:
   |      reason (IN) -- เหตุผลที่ต้องการปิด NFC
   *--------------------------------------------------------------------------*/
  void _stopNFCSession(String reason) => 
    (!nfcCubit.isClosed && nfcCubit.state.isNFCEnabled) ? nfcCubit.stopSession(reason: reason) : null;
}
