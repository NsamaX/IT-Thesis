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

    return BlocBuilder<AppStateCubit, AppState>(
      builder: (context, state) {
        final currentGame = state.selectedGame;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureItem(
                context,
                image: AppImages.game[currentGame],
                label: null,
                onTap: () => _navigateToSearch(context, currentGame),
              ),
              _buildFeatureItem(
                context,
                image: null,
                label: locale.translate('title.games'),
                onTap: () => _navigateToGames(context),
              ),
              _buildFeatureItem(
                context,
                image: null,
                label: locale.translate('title.custom'),
                onTap: () => _navigateToCustom(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required String? image,
    required String? label,
    required VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: _buildFeatureContent(context, image: image, label: label),
        ),
      ),
    );
  }

  Widget _buildFeatureContent(
    BuildContext context, {
    required String? image,
    required String? label,
  }) {
    final theme = Theme.of(context);

    if (image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(image, fit: BoxFit.cover),
      );
    } else {
      return Center(
        child: Text(
          label ?? '',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.black),
        ),
      );
    }
  }

  void _navigateToSearch(BuildContext context, String? currentGame) {
    Navigator.of(context).pushNamed(
      AppRoutes.search,
      arguments: {'game': currentGame},
    );
  }

  void _navigateToGames(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.games);
  }

  void _navigateToCustom(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.card,
      arguments: {'isCustom': true},
    );
  }
}
