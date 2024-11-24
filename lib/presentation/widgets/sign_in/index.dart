import 'package:flutter/material.dart';
import '../../../core/locales/localizations.dart';
import '../../../core/routes/route.dart';

class IndexWidget extends StatelessWidget {
  const IndexWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).translate('index_title'),
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              Text(
                AppLocalizations.of(context).translate('index_description'),
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
                    AppLocalizations.of(context)
                        .translate('index_button_start'),
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
