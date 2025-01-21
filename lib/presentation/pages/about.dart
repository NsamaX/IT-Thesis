import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import '../widgets/app_bar.dart';

class AboutPage extends StatelessWidget {
  //---------------------------------- Build ---------------------------------//
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
    );
  }

  //--------------------------------- App Bar --------------------------------//
  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) => {
    Icons.arrow_back_ios_new_rounded: '/back',
    locale.translate('title.about'): null,
    null: null,
  };
}
