import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';

import '../cubits/settings.dart';
import '../widgets/labels/setting.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_navigation_bar.dart';

class SettingsPage extends StatelessWidget {
  //---------------------------------- Build ---------------------------------//
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final cubit = context.read<SettingsCubit>();
    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
      body: _buildBody(context, locale, cubit),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }

  //--------------------------------- App Bar --------------------------------//
  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) => {locale.translate('title.settings'): null};
  
  //---------------------------------- Body ----------------------------------//
  Widget _buildBody(BuildContext context, AppLocalizations locale, SettingsCubit cubit) => SettingLabelWidget(
    label: [
      _buildAccountSettings(locale),
      _buildGeneralSettings(context, locale, cubit),
      _buildSupportSettings(context, locale, cubit),
    ],
  );

  Map<String, dynamic> _buildAccountSettings(AppLocalizations locale) => {
    'title': locale.translate('settings.account.label'),
    'content': [
      {
        'onTap': () {},
        'icon': Icons.account_circle_rounded,
        'text': locale.translate('settings.account.email'),
      },
      {
        'onTap': AppRoutes.library,
        'icon': Icons.bookmark_added_rounded,
        'text': locale.translate('settings.account.library'),
      },
    ],
  };

  Map<String, dynamic> _buildGeneralSettings(BuildContext context, AppLocalizations locale, SettingsCubit cubit) => {
    'title': locale.translate('settings.general.label'),
    'content': [
      {
        'onTap': AppRoutes.about,
        'icon': Icons.auto_stories_rounded,
        'text': locale.translate('settings.general.about'),
      },
      {
        'onTap': AppRoutes.privacy,
        'icon': Icons.privacy_tip_rounded,
        'text': locale.translate('settings.general.privacy'),
      },
      {
        'onTap': () => _toggleSignOut(context, cubit),
        'icon': Icons.logout_rounded,
        'text': locale.translate('settings.general.sign_out'),
      },
    ],
  };

  Map<String, dynamic> _buildSupportSettings(BuildContext context, AppLocalizations locale, SettingsCubit cubit) => {
    'title': locale.translate('settings.support.label'),
    'content': [
      {
        'onTap': AppRoutes.language,
        'icon': Icons.language_rounded,
        'text': locale.translate('settings.support.language'),
        'info': AppLocalizations.getLanguageName(locale.locale.languageCode),
      },
      // {
      //   'onTap': () {},
      //   'icon': Icons.coffee_rounded,
      //   'text': locale.translate('settings.support.donate'),
      // },
    ],
  };

  //--------------------------------- Feature --------------------------------//
  void _toggleSignOut(BuildContext context, SettingsCubit cubit) {
    cubit.updateSetting('firstLoad', true);
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
  }
}
