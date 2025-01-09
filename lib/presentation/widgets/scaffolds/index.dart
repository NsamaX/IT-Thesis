import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';

class IndexScaffoldWidget extends StatelessWidget {
  const IndexScaffoldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(context),
              const SizedBox(height: 30),
              _buildDescription(context),
              const SizedBox(height: 38),
              _buildSignInButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Text(
      locale.translate('title.index'),
      style: theme.textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Text(
      locale.translate('tutorial.index'),
      style: theme.textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return SizedBox(
      width: 132,
      height: 46,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signIn),
        child: Text(locale.translate('button.start')),
      ),
    );
  }
}
