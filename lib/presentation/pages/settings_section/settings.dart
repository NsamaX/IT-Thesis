import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/route.dart';
import '../../blocs/locale.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/bar/bottom_navigation.dart';
import '../../widgets/label/settings.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final cubit = context.read<LocaleCubit>();
    return Scaffold(
      appBar: AppBarWidget(menu: {locale.translate('settings.title'): null}),
      body: SettingsLabelWidget(
        label: [
          {
            'title': locale.translate('settings.account.title'),
            'content': [
              {
                'icon': Icons.account_circle,
                'text': locale.translate('settings.account.email'),
                'onTap': () {},
              },
              {
                'icon': Icons.bookmark_added_rounded,
                'text': locale.translate('settings.account.library'),
                'onTap': AppRoutes.library,
              },
            ]
          },
          {
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
                'onTap': AppRoutes.signIn,
              },
            ]
          },
          {
            'title': locale.translate('settings.support.title'),
            'content': [
              {
                'icon': Icons.language_rounded,
                'text': locale.translate('settings.support.language'),
                'onTap': () {
                  if (cubit.state.locale.languageCode == 'en') {
                    cubit.updateLanguage('ja');
                  } else {
                    cubit.updateLanguage('en');
                  }
                },
              },
              {
                'icon': Icons.coffee_rounded,
                'text': locale.translate('settings.support.donate'),
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
