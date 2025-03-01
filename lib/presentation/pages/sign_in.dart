import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';

import '../cubits/app_state.dart';
import '../cubits/settings.dart';

class SignInPage extends StatelessWidget {
  //---------------------------------- Build ---------------------------------//
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(locale, theme),
            const SizedBox(height: 80.0),
            _buildGoogleSignInButton(),
            const SizedBox(height: 80.0),
            _buildGuestSignInButton(context, locale),
          ],
        ),
      ),
    );
  }

  //--------------------------------- Widgets --------------------------------//
  Widget _buildTitle(AppLocalizations locale, ThemeData theme) => Text(
    locale.translate('title.sign_in'),
    style: theme.textTheme.titleLarge,
    textAlign: TextAlign.center,
  );

  Widget _buildGoogleSignInButton() => GestureDetector(
    onTap: () {
      // TODO: Implement Google sign-in functionality
    },
    child: Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.5 * 255).toInt()),
            offset: const Offset(1.0, 1.0),
            blurRadius: 3.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: const Image(image: AssetImage('assets/images/google.png')),
    ),
  );

  Widget _buildGuestSignInButton(BuildContext context, AppLocalizations locale) => SizedBox(
    width: 132,
    height: 46,
    child: ElevatedButton(
      onPressed: () => _handleGuestSignIn(context),
      child: Text(locale.translate('button.guest')),
    ),
  );

  void _handleGuestSignIn(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();
    final appCubit = context.read<AppCubit>();
    settingsCubit.updateFirstLoad(false);
    appCubit.updatePageIndex(0);
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.myDecks,
      (_) => false,
    );
  }
}
