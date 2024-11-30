import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/image.dart';
import '../../../core/locales/localizations.dart';
import '../../../core/routes/route.dart';
import '../../blocs/game_selection.dart';

class FeaturesDrawerWidget extends StatelessWidget {
  const FeaturesDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentGame = context.watch<GameSelectionCubit>().state;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildItem(
            context,
            AppImages.game[currentGame],
            null,
            () {
              Navigator.of(context).pushNamed(
                AppRoutes.search,
                arguments: {'game': currentGame},
              );
            },
          ),
          buildItem(
            context,
            null,
            AppLocalizations.of(context).translate('other.title'),
            () {
              Navigator.of(context).pushNamed(AppRoutes.other);
            },
          ),
          buildItem(
            context,
            null,
            AppLocalizations.of(context).translate('custom.title'),
            () {
              Navigator.of(context).pushNamed(
                AppRoutes.cardInfo,
                arguments: {'isCustom': true},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildItem(
    BuildContext context,
    String? image,
    String? label,
    VoidCallback? onTapFunction,
  ) {
    final theme = Theme.of(context);
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
