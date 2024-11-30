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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).translate('index.title'),
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                AppLocalizations.of(context).translate('index.description'),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 38),
              SizedBox(
                width: 132,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.signIn);
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
