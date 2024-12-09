import 'package:flutter/widgets.dart';
import 'package:nfc_project/presentation/blocs/NFC.dart';

class NFCSessionHandler with WidgetsBindingObserver {
  final NFCCubit nfcCubit;

  NFCSessionHandler(this.nfcCubit);

  void initNFCSessionHandler() {
    WidgetsBinding.instance.addObserver(this);
  }

  void disposeNFCSessionHandler() {
    WidgetsBinding.instance.removeObserver(this);
    stopNFCSession('Page disposed');
  }

  void handleAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      stopNFCSession('App moved to background or detached: $state');
    }
  }

  void stopNFCSession(String reason) {
    if (!nfcCubit.isClosed && nfcCubit.state.isNFCEnabled) {
      nfcCubit.stopSession(reason: reason);
      debugPrint('NFC session stopped: $reason');
    }
  }
}
