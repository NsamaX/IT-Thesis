import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/locales/localizations.dart';
import '../../../core/routes/route.dart';
import '../../../domain/entities/card.dart';
import '../../blocs/deck_manager.dart';

class CardWidget extends StatelessWidget {
  final CardEntity card;

  const CardWidget({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.cardDetail,
              arguments: {'card': card},
            );
          },
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Card(
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: card.imageUrl != null
                    ? Image.network(card.imageUrl!)
                    : Container(
                        color: theme.appBarTheme.backgroundColor,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_not_supported,
                                size: 36,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('no_card_image'),
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
        if (!context.watch<DeckMangerCubit>().state.isEditMode)
          Positioned(
            top: 0,
            right: 0,
            child: Column(
              children: [
                buildCardCountDisplay(context, 1),
                buildCircleButton(
                  context,
                  Icons.add,
                  () {},
                ),
                buildCircleButton(
                  context,
                  Icons.remove,
                  () {},
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget buildCardCountDisplay(
    BuildContext context,
    int count,
  ) {
    final theme = Theme.of(context);
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.secondaryHeaderColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildCircleButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.secondaryHeaderColor,
          ),
        ),
      ),
    );
  }
}
