import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/locales/localizations.dart';
import '../../core/routes/route.dart';
import '../../data/datasources/remote/api_config.dart';
import '../blocs/bottom_nav_cubit.dart';
import '../blocs/locale_cubit.dart';
import '../widgets/app_bar.dart';
import '../widgets/label.dart';
import '../widgets/nar_bar.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<BottomNavCubit>().updateIndex(2);

    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          AppLocalizations.of(context).translate('setting_title'): null,
        },
      ),
      body: LabelWidget(
        label: [
          {
            'title': AppLocalizations.of(context)
                .translate('setting_account_section'),
            'content': [
              {
                'icon': Icons.account_circle,
                'text': AppLocalizations.of(context)
                    .translate('setting_account_email'),
                'onTap': () {},
              },
              {
                'icon': Icons.bookmark_added_rounded,
                'text': AppLocalizations.of(context)
                    .translate('setting_account_my_card'),
                'onTap': AppRoutes.myCard,
              },
            ]
          },
          {
            'title': AppLocalizations.of(context)
                .translate('setting_general_section'),
            'content': [
              {
                'icon': Icons.auto_stories_rounded,
                'text': AppLocalizations.of(context)
                    .translate('setting_general_about'),
                'onTap': () {},
              },
              {
                'icon': Icons.privacy_tip_rounded,
                'text': AppLocalizations.of(context)
                    .translate('setting_general_privacy'),
                'onTap': () {},
              },
              {
                'icon': Icons.logout_rounded,
                'text': AppLocalizations.of(context)
                    .translate('setting_general_sign_out'),
                'onTap': AppRoutes.signIn,
              },
            ]
          },
          {
            'title': AppLocalizations.of(context)
                .translate('setting_support_section'),
            'content': [
              {
                'icon': Icons.language_rounded,
                'text': AppLocalizations.of(context)
                    .translate('setting_support_language'),
                'onTap': () {
                  final currentLocale =
                      context.read<LocaleCubit>().state.locale;
                  if (currentLocale.languageCode == 'en') {
                    context.read<LocaleCubit>().changeLocale('ja');
                  } else {
                    context.read<LocaleCubit>().changeLocale('en');
                  }
                },
              },
              {
                'icon': Icons.coffee_rounded,
                'text': AppLocalizations.of(context)
                    .translate('setting_support_donate'),
                'onTap': () {},
              },
            ]
          },
          {
            'title': 'API',
            'content': [
              {
                'icon': Icons.api_rounded,
                'text': '${ApiConfig.baseUrls?['vanguard'] ?? 'None'}',
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
