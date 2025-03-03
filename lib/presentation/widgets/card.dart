import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/domain/entities/card.dart';

import '../cubits/deck_management/cubit.dart';
import '../cubits/NFC/cubit.dart';
import 'card/edit_controls.dart';

class CardWidget extends StatelessWidget {
  final CardEntity card;
  final int count;

  const CardWidget({
    Key? key,
    required this.card,
    this.count = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deckManagerState = context.watch<DeckManagerCubit>().state;

    return Stack(
      children: [
        _buildCardContainer(
          context,
          theme,
          deckManagerState.selectedCard == card,
          deckManagerState.isNFCEnabled,
        ),
        if (deckManagerState.isEditModeEnabled && !deckManagerState.isNFCEnabled) 
          buildEditControls(context, card, count),
      ],
    );
  }

  /// Card container with gesture detection
  Widget _buildCardContainer(BuildContext context, ThemeData theme, bool isSelected, bool isNFCEnabled) {
    return GestureDetector(
      onTap: () => _handleCardTap(context, isNFCEnabled),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Opacity(
          opacity: _calculateOpacity(isNFCEnabled, isSelected),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.appBarTheme.backgroundColor,
            ),
            child: Card(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: card.imageUrl != null
                    ? Image.network(
                        card.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildImageError(),
                      )
                    : _buildImageError(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handle card tap actions
  void _handleCardTap(BuildContext context, bool isNFCEnabled) {
    final cubit = context.read<DeckManagerCubit>();
    if (isNFCEnabled) {
      cubit.toggleSelectCard(card);
      _handleNfcToggle(context, cubit);
    } else {
      Navigator.of(context).pushNamed(
        AppRoutes.card,
        arguments: {'card': card},
      );
    }
  }

  /// Handle NFC toggle action
  void _handleNfcToggle(BuildContext context, DeckManagerCubit cubit) {
    final selectedCard = cubit.state.selectedCard;
    if (selectedCard != null) {
      final nfcCubit = context.read<NFCCubit>();
      NFCHelper.handleToggleNFC(
        nfcCubit,
        enable: true,
        card: selectedCard,
        reason: 'User selected a card to write to NFC tag.',
      );
    }
  }

  /// Calculate opacity for card
  double _calculateOpacity(bool isNFCEnabled, bool isSelected) => isNFCEnabled ? (isSelected ? 1.0 : 0.4) : 1.0;

  /// Error widget for image loading
  Widget _buildImageError() => const Center(
    child: Icon(
      Icons.image_not_supported,
      size: 36,
      color: Colors.grey,
    ),
  );
}
