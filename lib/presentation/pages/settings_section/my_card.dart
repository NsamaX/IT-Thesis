import 'package:flutter/material.dart';
import '../../../core/locales/localizations.dart';
import '../../widgets/bar/app.dart';

class MyCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          Icons.arrow_back_ios_new_rounded: '/back',
          AppLocalizations.of(context).translate('my_card_title'): null,
          null: null,
        },
      ),
    );
  }
}
