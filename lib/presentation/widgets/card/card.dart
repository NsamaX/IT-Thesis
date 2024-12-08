import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/routes/route.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../../blocs/deck_manager.dart';

class CardWidget extends StatelessWidget {
  final CardEntity card;
  final int? count;

  const CardWidget({
    Key? key,
    required this.card,
    this.count = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = context.watch<DeckManagerCubit>().state.selectedCard == card;
    final isNfcReadEnabled = context.watch<DeckManagerCubit>().state.isNfcReadEnabled;
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (isNfcReadEnabled) {
              context.read<DeckManagerCubit>().toggleSelectedCard(card);
            } else {
              Navigator.of(context).pushNamed(
                AppRoutes.card,
                arguments: {'card': card},
              );
            }
          },
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Opacity(
              opacity: isNfcReadEnabled ? (isSelected ? 1.0 : 0.4) : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.appBarTheme.backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: Offset(3, 4),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Card(
                  elevation: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: card.imageUrl != null
                        ? Image.network(
                            card.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: theme.appBarTheme.backgroundColor,
                                child: Center(
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 36,
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 36,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (context.watch<DeckManagerCubit>().state.isEditMode && !isNfcReadEnabled)
          Positioned(
            top: 0,
            right: 0,
            child: Column(
              children: [
                _buildCount(theme, count!),
                _buildButton(
                  theme,
                  Icons.add,
                  () => context.read<DeckManagerCubit>().addCard(card),
                ),
                _buildButton(
                  theme,
                  Icons.remove,
                  () => context.read<DeckManagerCubit>().removeCard(card),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCount(ThemeData theme, int count) {
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
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.secondaryHeaderColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildButton(ThemeData theme, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
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
