import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/constants/images.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import '../../cubits/app_state.dart';

class FeaturesDrawerWidget extends StatelessWidget {
  const FeaturesDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final currentGame = state.selectedGame;

        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureItem(
                theme,
                onTap: () => _navigateToRoute(context, AppRoutes.search, {'game': currentGame}),
                image: AppImages.game[currentGame],
              ),
              _buildFeatureItem(
                theme,
                onTap: () => _navigateToRoute(context, AppRoutes.games),
                label: locale.translate('title.games'),
              ),
              _buildFeatureItem(
                theme,
                onTap: () => _navigateToRoute(context, AppRoutes.card, {'isCustom': true}),
                label: locale.translate('title.custom'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToRoute(BuildContext context, String route, [Map<String, dynamic>? arguments]) {
    Navigator.of(context).pushNamed(route, arguments: arguments);
  }

  Widget _buildFeatureItem(
    ThemeData theme, {
    VoidCallback? onTap,
    String? image,
    String? label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.0,
                spreadRadius: 1.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildFeatureContent(theme, image: image, label: label),
        ),
      ),
    );
  }

  Widget _buildFeatureContent(
    ThemeData theme, {
    String? image,
    String? label,
  }) {
    if (image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        ),
      );
    }

    return Center(
      child: Text(
        label ?? '',
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.black),
      ),
    );
  }
}
