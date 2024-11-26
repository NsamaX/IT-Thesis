import 'package:flutter/material.dart';
import '../../../core/locales/localizations.dart';
import '../../../core/routes/route.dart';

class IndexWidget extends StatelessWidget {
  const IndexWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).translate('index.title'),
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              Text(
                AppLocalizations.of(context).translate('index.description'),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.signIn);
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('index.button'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
