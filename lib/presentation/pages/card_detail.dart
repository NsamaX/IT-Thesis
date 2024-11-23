import 'package:flutter/material.dart';
import '../../core/locales/localizations.dart';
import '../widgets/app_bar.dart';
import '../widgets/card_detail.dart';

class CardDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          Icons.arrow_back_ios_new_rounded: '/back',
          AppLocalizations.of(context).translate('card_info_title'): null,
          Icons.wifi_tethering_rounded: null,
        },
      ),
      body: CardInfoWidget(),
    );
  }
}
