import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import '../../cubits/app_state.dart';
import '../../cubits/settings.dart';

class SignInScaffoldWidget extends StatelessWidget {
  const SignInScaffoldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(context),
            const SizedBox(height: 80),
            _buildGoogleIcon(),
            const SizedBox(height: 80),
            _buildSignInButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Text(
      locale.translate('title.sign_in'),
      style: theme.textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGoogleIcon() {
    return GestureDetector(
      onTap: () {},
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
        child: const Image(
          image: AssetImage('assets/images/google.png'),
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return SizedBox(
      width: 132,
      height: 46,
      child: ElevatedButton(
        onPressed: () {
          context.read<SettingsCubit>().updateFirstLoad(false);
          context.read<AppStateCubit>().updatePageIndex(0);
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.myDecks,
            (_) => false,
          );
        },
        child: Text(locale.translate('button.guest')),
      ),
    );
  }
}
