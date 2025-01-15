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
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final currentGame = state.selectedGame;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureItem(
                context,
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.search,
                  arguments: {'game': currentGame},
                ),
                image: AppImages.game[currentGame],
                label: null,
              ),
              _buildFeatureItem(
                context,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.games),
                image: null,
                label: locale.translate('title.games'),
              ),
              _buildFeatureItem(
                context,
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.card,
                  arguments: {'isCustom': true},
                ),
                image: null,
                label: locale.translate('title.custom'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
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
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: _buildFeatureContent(context, image: image, label: label),
        ),
      ),
    );
  }

  Widget _buildFeatureContent(
    BuildContext context, {
    String? image,
    String? label,
  }) {
    final theme = Theme.of(context);
    if (image != null) return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(image, fit: BoxFit.cover),
    );
    return Center(
      child: Text(
        label ?? '',
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.black),
      ),
    );
  }
}
