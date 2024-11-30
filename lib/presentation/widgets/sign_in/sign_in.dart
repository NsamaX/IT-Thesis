import 'package:flutter/material.dart';
import '../../../core/locales/localizations.dart';
import '../../../core/routes/route.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

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
                AppLocalizations.of(context).translate('sign_in.title'),
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 84),
              Container(
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
              const SizedBox(height: 82),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.read,
                      (_) => false,
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('sign_in.button'),
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
