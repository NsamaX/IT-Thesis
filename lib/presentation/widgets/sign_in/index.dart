import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/route.dart';

class IndexWidget extends StatelessWidget {
  const IndexWidget({Key? key}) : super(key: key);

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
              _buildTitle(theme, locale),
              const SizedBox(height: 30),
              _buildDescription(theme, locale),
              const SizedBox(height: 38),
              _buildSignInButton(context, locale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme, AppLocalizations locale) {
    return Text(
      locale.translate('index.title'),
      style: theme.textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(ThemeData theme, AppLocalizations locale) {
    return Text(
      locale.translate('index.description'),
      style: theme.textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignInButton(BuildContext context, AppLocalizations locale) {
    return SizedBox(
      width: 132,
      height: 46,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signIn),
        child: Text(locale.translate('index.button')),
      ),
    );
  }
}
