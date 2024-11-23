import 'package:flutter/material.dart';
import '../../core/locales/localizations.dart';
import '../widgets/app_bar.dart';

class TrackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          Icons.arrow_back_ios_new_rounded: '/back',
          0.toString(): null,
          AppLocalizations.of(context).translate('track_title'): null,
          Icons.refresh_rounded: null,
          Icons.wifi_tethering_rounded: null,
        },
      ),
    );
  }
}
