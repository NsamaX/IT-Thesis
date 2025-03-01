import 'package:flutter/widgets.dart';

import 'package:nfc_project/presentation/cubits/NFC.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class NFCSessionHandler with WidgetsBindingObserver {
  final NFCCubit nfcCubit;

  NFCSessionHandler(this.nfcCubit);

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void initNFCSessionHandler() {
    WidgetsBinding.instance.addObserver(this);
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void disposeNFCSessionHandler() {
    WidgetsBinding.instance.removeObserver(this);
    _stopNFCSession('Page disposed');
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
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

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void _stopNFCSession(String reason) => (!nfcCubit.isClosed && nfcCubit.state.isNFCEnabled) 
  ? nfcCubit.stopSession(reason: reason) : null;
}
