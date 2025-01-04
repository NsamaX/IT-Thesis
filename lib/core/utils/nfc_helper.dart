import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/presentation/cubits/NFC.dart';

/// ตัวช่วยสำหรับจัดการการเปิด/ปิด NFC ผ่าน NFCCubit
class NFCHelper {
  static Future<void> handleToggleNFC(
    NFCCubit cubit, {
    required bool enable,
    CardEntity? card,
    String? reason,
  }) async {
    if (cubit.isClosed) return;
    if (enable) {
      if (!cubit.state.isNFCEnabled) cubit.toggleNFC();
      if (!cubit.state.isProcessing) {
        try {
          await cubit.startSession(card: card);
        } catch (e) {
          cubit.clearErrorMessage();
        }
      } else if (card != null && cubit.state.isNFCEnabled) {
        await cubit.restartSessionIfNeeded(card: card);
      }
    } else {
      await cubit.stopSession(reason: reason ?? 'User toggled off NFC');
      await Future.delayed(Duration(milliseconds: 300));
    }
  }
}
