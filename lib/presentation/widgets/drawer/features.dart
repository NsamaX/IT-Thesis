import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/constants/image.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/route.dart';
import '../../blocs/app_state.dart';

class FeaturesDrawerWidget extends StatelessWidget {
  const FeaturesDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocBuilder<AppStateCubit, AppState>(
      builder: (context, state) {
        final currentGame = state.selectedGame;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildItem(
                theme,
                AppImages.game[currentGame],
                null,
                () => Navigator.of(context).pushNamed(
                  AppRoutes.search,
                  arguments: {'game': currentGame},
                ),
              ),
              _buildItem(
                theme,
                null,
                locale.translate('games.title'),
                () => Navigator.of(context).pushNamed(AppRoutes.games),
              ),
              _buildItem(
                theme,
                null,
                locale.translate('custom.title'),
                () => Navigator.of(context).pushNamed(
                  AppRoutes.card,
                  arguments: {'isCustom': true},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(ThemeData theme, String? image, String? label, VoidCallback? onTapFunction) {
    final double boxSize = 60;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: onTapFunction,
        child: Container(
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: image != null
              ? Padding(
                  padding: const EdgeInsets.all(6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(image, fit: BoxFit.cover),
                  ),
                )
              : Center(
                  child: Text(
                    label ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.black),
                  ),
                ),
        ),
      ),
    );
  }
}
