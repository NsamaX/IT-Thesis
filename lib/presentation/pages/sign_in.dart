import 'package:flutter/material.dart';
import '../../core/locales/localizations.dart';
import '../../core/routes/route.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).translate('sign_in_title'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 52),
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
              const SizedBox(height: 52),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.read,
                      (_) => false,
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('sign_in_guest'),
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
