import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import '../../blocs/settings.dart';
import '../../widgets/label/settings.dart';
import '../../widgets/navigation_bar/app.dart';
import '../../widgets/navigation_bar/bottom.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final cubit = context.read<SettingsCubit>();

    return Scaffold(
      appBar: AppBarWidget(menu: {locale.translate('settings.title'): null}),
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
      'title': locale.translate('settings.account.title'),
      'content': [
        {
          'icon': Icons.account_circle_rounded,
          'text': locale.translate('settings.account.email'),
          'onTap': () {},
        },
        {
          'icon': Icons.bookmark_added_rounded,
          'text': locale.translate('settings.account.library'),
          'onTap': AppRoutes.library,
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
      'title': locale.translate('settings.general.title'),
      'content': [
        {
          'icon': Icons.auto_stories_rounded,
          'text': locale.translate('settings.general.about'),
          'onTap': () {},
        },
        {
          'icon': Icons.privacy_tip_rounded,
          'text': locale.translate('settings.general.privacy'),
          'onTap': () {},
        },
        {
          'icon': Icons.logout_rounded,
          'text': locale.translate('settings.general.sign_out'),
          'onTap': () => _toggleSignOut(context, cubit),
        },
      ],
    };
  }

  Map<String, dynamic> _buildSupportSettings(
    AppLocalizations locale,
    SettingsCubit cubit,
  ) {
    return {
      'title': locale.translate('settings.support.title'),
      'content': [
        {
          'icon': Icons.language_rounded,
          'text': locale.translate('settings.support.language'),
          'onTap': () => _toggleLanguage(cubit),
        },
        // {
        //   'icon': Icons.coffee_rounded,
        //   'text': locale.translate('settings.support.donate'),
        //   'onTap': () {},
        // },
      ],
    };
  }

  void _toggleSignOut(BuildContext context, SettingsCubit cubit) {
    cubit.updateFirstLoad(true);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
  }

  void _toggleLanguage(SettingsCubit cubit) {
    final currentLanguage = cubit.state.locale.languageCode;
    cubit.updateLanguage(currentLanguage == 'en' ? 'ja' : 'en');
  }
}
