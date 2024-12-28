import 'package:flutter/material.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/presentation/cubits/NFC.dart';

class NFCHelper {
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
