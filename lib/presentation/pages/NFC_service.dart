import 'package:flutter/material.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../blocs/NFC.dart';

class NFCService with WidgetsBindingObserver {
  final NFCCubit nfcCubit;

  NFCService(this.nfcCubit) {
    WidgetsBinding.instance.addObserver(this);
  }

  void startNFCSession(CardEntity? card) {
    if (!nfcCubit.isClosed && !nfcCubit.state.isProcessing) {
      nfcCubit.toggleNFC();
      if (nfcCubit.state.isNFCEnabled && card != null) {
        nfcCubit.start(card: card);
      }
    }
  }

  void stopNFCSession(String reason) {
    try {
      if (!nfcCubit.isClosed && nfcCubit.state.isNFCEnabled) {
        nfcCubit.stopSession(reason: reason);
        debugPrint('NFC session stopped: $reason');
      }
    } catch (e) {
      debugPrint('Error stopping NFC session: $e');
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopNFCSession('Service disposed');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      stopNFCSession('App moved to background: $state');
    }
  }
}
