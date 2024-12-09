import 'package:flutter/material.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/presentation/blocs/NFC.dart';

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

    if (enable && !cubit.state.isProcessing) {
      cubit.toggleNFC();
      await cubit.start(card: card);
    } else if (!enable) {
      await cubit.stopSession(reason: reason ?? 'User toggled off NFC');
      await Future.delayed(Duration(milliseconds: 300));
    }
  }
}
