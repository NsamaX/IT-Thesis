import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import '../widgets/navigation_bar/app.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
    );
  }

  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) {
    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      locale.translate('title.about'): null,
      null: null,
    };
  }
}
