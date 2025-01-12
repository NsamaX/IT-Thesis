import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/card.dart';

class CardImageWidget extends StatelessWidget {
  final CardEntity? card;
  final bool isCustom;

  const CardImageWidget({
    Key? key,
    this.card,
    this.isCustom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCustom
        ? _buildDottedBorder(context)
        : _buildImage(context, card: card);
  }

  Widget _buildDottedBorder(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: DottedBorder(
        color: Colors.white.withOpacity(0.4),
        borderType: BorderType.RRect,
        radius: const Radius.circular(16.0),
        dashPattern: const [14.0, 24.0],
        strokeWidth: 2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.upload_rounded, 
                size: 36.0,
              ),
              Text(
                locale.translate('text.upload_image'),
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(
    BuildContext context, {
    CardEntity? card,
  }) {
    if (card == null || card.imageUrl == null) return _buildErrorImage(context);
    
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(3.0, 4.0),
            blurRadius: 12.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Image.network(
            card.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildErrorImage(context),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorImage(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      color: theme.appBarTheme.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_not_supported, 
              size: 36.0,
            ),
            Text(
              locale.translate('text.no_card_image'),
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
