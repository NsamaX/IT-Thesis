import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';

import 'package:nfc_project/domain/entities/card.dart';

import '../../cubits/deck_management/cubit.dart';
import '../../cubits/NFC/cubit.dart';

import 'card_editor.dart';

class CardWidget extends StatelessWidget {
  final CardEntity card;
  final int count;

  const CardWidget({
    super.key,
    required this.card,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deckManagerState = context.watch<DeckManagerCubit>().state;
    final bool isSelected = deckManagerState.selectedCard == card;
    final bool isNFCEnabled = deckManagerState.isNFCEnabled;
    final bool isEditMode = deckManagerState.isEditModeEnabled && !isNFCEnabled;

    return Stack(
      children: [
        _buildCardContainer(context, theme, isSelected, isNFCEnabled),
        if (isEditMode) buildCardEditor(context, card, count),
      ],
    );
  }

  Widget _buildCardContainer(
    BuildContext context, 
    ThemeData theme, 
    bool isSelected, 
    bool isNFCEnabled,
  ) {
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
                child: _buildCardImage(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardImage() {
    if (card.imageUrl == null || card.imageUrl!.isEmpty) return _buildImageError();

    return Image.network(
      card.imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildImageError(),
    );
  }

  void _handleCardTap(
    BuildContext context, 
    bool isNFCEnabled,
  ) {
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

  void _handleNfcToggle(
    BuildContext context, 
    DeckManagerCubit cubit,
  ) {
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

  double _calculateOpacity(
    bool isNFCEnabled, 
    bool isSelected,
  ) {
    return isNFCEnabled ? (isSelected ? 1.0 : 0.4) : 1.0;
  }

  Widget _buildImageError() {
    return const Center(
      child: Icon(
        Icons.image_not_supported,
        size: 36,
        color: Colors.grey,
      ),
    );
  }
}
