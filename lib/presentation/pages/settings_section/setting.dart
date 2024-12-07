import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/route.dart';
import '../../blocs/locale.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/bar/bottom_navigation.dart';
import '../../widgets/label/settings.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          AppLocalizations.of(context).translate('setting.title'): null,
        },
      ),
      body: SettingsLabelWidget(
        label: [
          {
            'title': AppLocalizations.of(context).translate('setting.account.title'),
            'content': [
              {
                'icon': Icons.account_circle,
                'text': AppLocalizations.of(context).translate('setting.account.email'),
                'onTap': () {},
              },
              {
                'icon': Icons.bookmark_added_rounded,
                'text': AppLocalizations.of(context).translate('setting.account.my_card'),
                'onTap': AppRoutes.myCard,
              },
            ]
          },
          {
            'title': AppLocalizations.of(context).translate('setting.general.title'),
            'content': [
              {
                'icon': Icons.auto_stories_rounded,
                'text': AppLocalizations.of(context).translate('setting.general.about'),
                'onTap': () {},
              },
              {
                'icon': Icons.privacy_tip_rounded,
                'text': AppLocalizations.of(context).translate('setting.general.privacy'),
                'onTap': () {},
              },
              {
                'icon': Icons.logout_rounded,
                'text': AppLocalizations.of(context).translate('setting.general.sign_out'),
                'onTap': AppRoutes.signIn,
              },
            ]
          },
          {
            'title': AppLocalizations.of(context).translate('setting.support.title'),
            'content': [
              {
                'icon': Icons.language_rounded,
                'text': AppLocalizations.of(context).translate('setting.support.language'),
                'onTap': () {
                  final currentLocale = context.read<LocaleCubit>().state;
                  if (currentLocale.locale.languageCode == 'en') {
                    context.read<LocaleCubit>().updateLanguage('ja');
                  } else {
                    context.read<LocaleCubit>().updateLanguage('en');
                  }
                },
              },
              {
                'icon': Icons.coffee_rounded,
                'text': AppLocalizations.of(context).translate('setting.support.donate'),
                'onTap': () {},
              },
            ]
          },
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
