import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/presentation/cubits/NFC.dart';

class NFCHelper {
  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน handleToggleNFC
   |
   |  วัตถุประสงค์:
   |      เปิดหรือปิดการใช้งาน NFC ตามค่าที่กำหนด และจัดการ session
   |
   |  พารามิเตอร์:
   |      cubit (IN)  -- NFCCubit ที่ใช้จัดการสถานะของ NFC
   |      enable (IN) -- กำหนดว่าจะเปิดหรือปิด NFC
   |      card (IN)   -- การ์ดที่ต้องการเชื่อมต่อ (ถ้ามี)
   |      reason (IN) -- เหตุผลที่ต้องการปิด NFC (ถ้ามี)
   *--------------------------------------------------------------------------*/
  static Future<void> handleToggleNFC(
    NFCCubit cubit, {
    required bool enable,
    CardEntity? card,
    String? reason,
  }) async {
    if (cubit.isClosed) return;

    try {
      enable ? await _enableNFC(cubit, card) : await _disableNFC(cubit, reason);
    } catch (e) {
      if (!cubit.isClosed) cubit.clearErrorMessage();
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _enableNFC
   |
   |  วัตถุประสงค์:
   |      เปิดใช้งาน NFC และเริ่ม session ถ้ายังไม่ได้เริ่ม
   |
   |  พารามิเตอร์:
   |      cubit (IN) -- NFCCubit ที่ใช้จัดการสถานะของ NFC
   |      card (IN)  -- การ์ดที่ต้องการเชื่อมต่อ (ถ้ามี)
   *--------------------------------------------------------------------------*/
  static Future<void> _enableNFC(NFCCubit cubit, CardEntity? card) async {
    if (!_isNFCEnabled(cubit)) cubit.toggleNFC();

    if (!_isProcessing(cubit)) {
      await cubit.startSession(card: card);
    } else if (card != null) {
      await cubit.restartSessionIfNeeded(card: card);
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _disableNFC
   |
   |  วัตถุประสงค์:
   |      ปิดใช้งาน NFC และหยุด session พร้อมดีเลย์เล็กน้อย
   |
   |  พารามิเตอร์:
   |      cubit (IN)  -- NFCCubit ที่ใช้จัดการสถานะของ NFC
   |      reason (IN) -- เหตุผลที่ต้องการปิด NFC (ถ้าไม่มีจะใช้ค่าเริ่มต้น)
   *--------------------------------------------------------------------------*/
  static Future<void> _disableNFC(NFCCubit cubit, String? reason) async {
    final String defaultReason = reason ?? 'User toggled off NFC';
    await cubit.stopSession(reason: defaultReason);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /*----------------------------------------------------------------------------
   |  Getter _isNFCEnabled
   |
   |  วัตถุประสงค์:
   |      คืนค่าสถานะว่าตอนนี้ NFC ถูกเปิดอยู่หรือไม่
   *--------------------------------------------------------------------------*/
  static bool _isNFCEnabled(NFCCubit cubit) => cubit.state.isNFCEnabled;

  /*----------------------------------------------------------------------------
   |  Getter _isProcessing
   |
   |  วัตถุประสงค์:
   |      คืนค่าสถานะว่าตอนนี้มีการประมวลผล NFC อยู่หรือไม่
   *--------------------------------------------------------------------------*/
  static bool _isProcessing(NFCCubit cubit) => cubit.state.isProcessing;
}
