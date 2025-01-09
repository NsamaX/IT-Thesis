import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/card.dart';

class CardImageWidget extends StatelessWidget {
  final CardEntity? card;
  final bool isCustom;

  const CardImageWidget({
    Key? key,
    required this.card,
    this.isCustom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCustom
        ? _buildDottedBorder(context)
        : _buildImage(context, card);
  }

  Widget _buildDottedBorder(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

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

  Widget _buildImage(BuildContext context, CardEntity? card) {
    if (card == null || card.imageUrl == null) return _buildErrorImage(context);

    final theme = Theme.of(context);
    const borderRadius = BorderRadius.all(Radius.circular(16));

    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(3, 4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
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
