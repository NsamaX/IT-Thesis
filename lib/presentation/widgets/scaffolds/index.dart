import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';

class IndexScaffoldWidget extends StatelessWidget {
  const IndexScaffoldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(locale, theme),
              const SizedBox(height: 30.0),
              _buildDescription(locale, theme),
              const SizedBox(height: 38.0),
              _buildSignInButton(context, locale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(AppLocalizations locale, ThemeData theme) {
    return Text(
      locale.translate('title.index'),
      style: theme.textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(AppLocalizations locale, ThemeData theme) {
    return Text(
      locale.translate('tutorial.index'),
      style: theme.textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignInButton(BuildContext context, AppLocalizations locale) {
    return SizedBox(
      width: 132.0,
      height: 46.0,
      child: ElevatedButton(
        onPressed: () => _navigateToSignIn(context),
        child: Text(locale.translate('button.start')),
      ),
    );
  }

  void _navigateToSignIn(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.signIn);
  }
}
