import 'package:flutter/material.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/presentation/cubits/NFC.dart';

/// ตัวช่วยสำหรับจัดการการเปิด/ปิด NFC ผ่าน NFCCubit
class NFCHelper {
  /// จัดการการเปิด/ปิด NFC
  /// - [cubit]: NFCCubit ที่ใช้ควบคุมสถานะ NFC
  /// - [enable]: กำหนดว่าให้เปิดหรือปิด NFC
  /// - [card]: การ์ดที่ต้องการส่งผ่าน หากเปิดใช้งาน NFC
  /// - [reason]: เหตุผลสำหรับการปิด NFC
  ///
  /// ขั้นตอนการทำงาน:
  /// 1. ตรวจสอบว่า Cubit ถูกปิดหรือไม่ หากปิดจะไม่ทำงาน
  /// 2. หากต้องการเปิด NFC:
  ///    - เปิดสถานะ NFC (ถ้ายังไม่เปิด)
  ///    - เริ่มกระบวนการ NFC หากยังไม่มีการประมวลผล
  /// 3. หากต้องการปิด NFC:
  ///    - หยุดเซสชัน NFC พร้อมส่งเหตุผล
  ///    - รอเพื่อให้กระบวนการหยุดสมบูรณ์
  static Future<void> handleToggleNFC(
    NFCCubit cubit, {
    required bool enable,
    CardEntity? card,
    String? reason,
  }) async {
    if (cubit.isClosed) {
      debugPrint('NFCCubit is already closed.');
      return;
    }
    if (enable) {
      if (!cubit.state.isNFCEnabled) cubit.toggleNFC();
      if (!cubit.state.isProcessing) {
        try {
          await cubit.start(card: card);
        } catch (e) {
          cubit.clearErrorMessage();
          debugPrint('Error during NFC Start: $e');
        }
      }
    } else {
      await cubit.stopSession(reason: reason ?? 'User toggled off NFC');
      await Future.delayed(Duration(milliseconds: 300));
    }
  }
}
