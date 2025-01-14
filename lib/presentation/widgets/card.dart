import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../cubits/deck_manager.dart';
import '../cubits/NFC.dart';
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
    final deckManagerState = context.watch<DeckManagerCubit>().state;
    final isSelected = deckManagerState.selectedCard == card;
    final isNfcReadEnabled = deckManagerState.isNfcReadEnabled;
    final isEditMode = deckManagerState.isEditMode;

    return Stack(
      children: [
        _buildCardContainer(context, isSelected, isNfcReadEnabled),
        if (isEditMode && !isNfcReadEnabled) buildEditControls(context, card: card, count: count),
      ],
    );
  }

  Widget _buildCardContainer(
    BuildContext context,
    bool isSelected,
    bool isNfcReadEnabled,
  ) {
    final theme = Theme.of(context);

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
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(3, 4),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Card(
              elevation: 4,
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

  void _handleCardTap(
      BuildContext context, 
      bool isNfcReadEnabled,
    ) {
    final cubit = context.read<DeckManagerCubit>();

    if (isNfcReadEnabled) {
      cubit.toggleSelectedCard(card);
      if (cubit.state.selectedCard != null) {
        final nfcCubit = context.read<NFCCubit>();
        NFCHelper.handleToggleNFC(
          nfcCubit,
          enable: true,
          card: cubit.state.selectedCard,
          reason: 'User selected a card to write to NFC tag.',
        );
      }
    } else {
      Navigator.of(context).pushNamed(
        AppRoutes.card,
        arguments: {'card': card},
      );
    }
  }

  Widget _buildImageError() {
    return const Center(
      child: Icon(
        Icons.image_not_supported,
        size: 36,
      ),
    );
  }
}
