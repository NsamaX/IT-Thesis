import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';

class IndexPage extends StatelessWidget {
  //---------------------------------- Build ---------------------------------//
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

  //--------------------------------- Widgets --------------------------------//
  Widget _buildTitle(AppLocalizations locale, ThemeData theme) => Text(
    locale.translate('title.index'),
    style: theme.textTheme.titleLarge,
    textAlign: TextAlign.center,
  );

  Widget _buildDescription(AppLocalizations locale, ThemeData theme) => Text(
    locale.translate('tutorial.index'),
    style: theme.textTheme.bodyMedium,
    textAlign: TextAlign.center,
  );

  Widget _buildSignInButton(BuildContext context, AppLocalizations locale) => SizedBox(
    width: 132.0,
    height: 46.0,
    child: ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signIn),
      child: Text(locale.translate('button.start')),
    ),
  );
}
