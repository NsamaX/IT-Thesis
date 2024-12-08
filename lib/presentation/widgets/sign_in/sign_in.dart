import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/route.dart';

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
            Text(
              locale.translate('sign_in.title'),
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 42),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
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
            ),
            const SizedBox(height: 42),
            SizedBox(
              width: 132,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.reader,
                  (_) => false,
                ),
                child: Text(locale.translate('sign_in.button')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
