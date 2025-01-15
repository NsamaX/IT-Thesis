import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/presentation/cubits/NFC.dart';

class NFCHelper {
  static Future<void> handleToggleNFC(
    NFCCubit cubit, {
    required bool enable,
    CardEntity? card,
    String? reason,
  }) async {
    if (cubit.isClosed) return;
    try {
      if (enable) {
        await _enableNFC(cubit, card);
      } else {
        await _disableNFC(cubit, reason);
      }
    } catch (e) {
      cubit.clearErrorMessage();
    }
  }

  static Future<void> _enableNFC(NFCCubit cubit, CardEntity? card) async {
    if (!_isNFCEnabled(cubit)) {
      cubit.toggleNFC();
    }
    if (!_isProcessing(cubit)) {
      await cubit.startSession(card: card);
    } else if (card != null) {
      await cubit.restartSessionIfNeeded(card: card);
    }
  }

  static bool _isNFCEnabled(NFCCubit cubit) => cubit.state.isNFCEnabled;

  static bool _isProcessing(NFCCubit cubit) => cubit.state.isProcessing;

  static Future<void> _disableNFC(NFCCubit cubit, String? reason) async {
    final String defaultReason = reason ?? 'User toggled off NFC';
    await cubit.stopSession(reason: defaultReason);
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
