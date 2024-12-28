import 'package:flutter/widgets.dart';
import 'package:nfc_project/presentation/cubits/NFC.dart';

class NFCSessionHandler with WidgetsBindingObserver {
  final NFCCubit nfcCubit;

  NFCSessionHandler(this.nfcCubit);

  void initNFCSessionHandler() {
    WidgetsBinding.instance.addObserver(this);
  }

  void disposeNFCSessionHandler() {
    WidgetsBinding.instance.removeObserver(this);
    _stopNFCSession('Page disposed');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    handleAppLifecycleState(state);
  }

  void handleAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _stopNFCSession('App moved to background or detached: $state');
    }
  }

  void _stopNFCSession(String reason) {
    if (!nfcCubit.isClosed && nfcCubit.state.isNFCEnabled) {
      nfcCubit.stopSession(reason: reason);
      debugPrint('NFC session stopped: $reason');
    }
  }
}
