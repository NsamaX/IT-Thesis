import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import '../cubits/settings.dart';
import '../widgets/labels/settings.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_navigation_bar.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final cubit = context.read<SettingsCubit>();

    return Scaffold(
      appBar: AppBarWidget(menu: {locale.translate('title.settings'): null}),
      body: _buildSettingsContent(context, locale, cubit),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }

  Widget _buildSettingsContent(
    BuildContext context,
    AppLocalizations locale,
    SettingsCubit cubit,
  ) {
    return SettingsLabelWidget(
      label: [
        _buildAccountSettings(locale),
        _buildGeneralSettings(context, locale, cubit),
        _buildSupportSettings(locale, cubit),
      ],
    );
  }

  Map<String, dynamic> _buildAccountSettings(AppLocalizations locale) {
    return {
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
  }

  Map<String, dynamic> _buildGeneralSettings(
    BuildContext context,
    AppLocalizations locale,
    SettingsCubit cubit,
  ) {
    return {
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
  }

  Map<String, dynamic> _buildSupportSettings(
    AppLocalizations locale,
    SettingsCubit cubit,
  ) {
    return {
      'title': locale.translate('settings.support.label'),
      'content': [
        {
          'onTap': () => _toggleLanguage(cubit),
          'icon': Icons.language_rounded,
          'text': locale.translate('settings.support.language'),
        },
        // {
        //   'onTap': () {},
        //   'icon': Icons.coffee_rounded,
        //   'text': locale.translate('settings.support.donate'),
        // },
      ],
    };
  }

  void _toggleSignOut(BuildContext context, SettingsCubit cubit) {
    cubit.updateFirstLoad(true);
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
  }

  void _toggleLanguage(SettingsCubit cubit) {
    final currentLanguage = cubit.state.locale.languageCode;
    cubit.updateLanguage(currentLanguage == 'en' ? 'ja' : 'en');
  }
}
