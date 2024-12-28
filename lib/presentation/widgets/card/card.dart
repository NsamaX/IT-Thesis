import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../../cubits/deck_manager.dart';
import 'edit_controls.dart';

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
    final deckManagerState = context.watch<DeckManagerCubit>().state;
    final isSelected = deckManagerState.selectedCard == card;
    final isNfcReadEnabled = deckManagerState.isNfcReadEnabled;
    final isEditMode = deckManagerState.isEditMode;

    return Stack(
      children: [
        _buildCardContainer(context, theme, isSelected, isNfcReadEnabled),
        if (isEditMode && !isNfcReadEnabled) buildEditControls(context, theme, card, count),
      ],
    );
  }

  void _handleCardTap(BuildContext context, bool isNfcReadEnabled) {
    if (isNfcReadEnabled) {
      context.read<DeckManagerCubit>().toggleSelectedCard(card);
    } else {
      Navigator.of(context).pushNamed(
        AppRoutes.card,
        arguments: {'card': card},
      );
    }
  }

  Widget _buildCardContainer(
    BuildContext context,
    ThemeData theme,
    bool isSelected,
    bool isNfcReadEnabled,
  ) {
    return GestureDetector(
      onTap: () => _handleCardTap(context, isNfcReadEnabled),
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
                  offset: const Offset(3, 4),
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
                        errorBuilder: (context, error, stackTrace) => _buildImageError(theme),
                      )
                    : _buildImageError(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageError(ThemeData theme) {
    return Container(
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 36,
        ),
      ),
    );
  }
}
