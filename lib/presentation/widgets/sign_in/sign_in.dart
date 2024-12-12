import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import '../../blocs/settings.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(theme, locale),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: _buildGoogleIcon(context),
            ),
            _buildSignInButton(context, locale),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme, AppLocalizations locale) {
    return Text(
      locale.translate('sign_in.title'),
      style: theme.textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGoogleIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // context.read<SettingsCubit>().updateFirstLoad(false);
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   AppRoutes.my_decks,
        //   (_) => false,
        // );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Image.asset('assets/images/google.png'),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context, AppLocalizations locale) {
    return SizedBox(
      width: 132,
      height: 46,
      child: ElevatedButton(
        onPressed: () {
          context.read<SettingsCubit>().updateFirstLoad(false);
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.my_decks,
            (_) => false,
          );
        },
        child: Text(locale.translate('sign_in.button')),
      ),
    );
  }
}
