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
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return isCustom
        ? _buildDottedBorder(locale, theme)
        : _buildImage(locale, theme, card);
  }

  Widget _buildDottedBorder(AppLocalizations locale, ThemeData theme) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: DottedBorder(
        color: Colors.white.withOpacity(0.4),
        borderType: BorderType.RRect,
        radius: const Radius.circular(16),
        dashPattern: const [16, 26],
        strokeWidth: 2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upload_rounded, size: 36),
              const SizedBox(height: 12),
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

  Widget _buildImage(AppLocalizations locale, ThemeData theme, CardEntity? card) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(3, 4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: card?.imageUrl != null
              ? Image.network(
                  card!.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildErrorImage(locale, theme),
                )
              : _buildErrorImage(locale, theme),
        ),
      ),
    );
  }

  Widget _buildErrorImage(AppLocalizations locale, ThemeData theme) {
    return Container(
      color: theme.appBarTheme.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image_not_supported, size: 36),
            const SizedBox(height: 8),
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
