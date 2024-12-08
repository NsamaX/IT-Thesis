import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/card.dart';

class CardDetailsWidget extends StatelessWidget {
  final CardEntity? card;
  final bool isCustom;

  const CardDetailsWidget({
    Key? key,
    this.card,
    this.isCustom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(40),
      child: ListView(
        children: [
          isCustom ? _buildDottedBorder(locale, theme) : _buildImage(locale, theme, card),
          const SizedBox(height: 26),
          Text(
            locale.translate('card.card_description'),
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _buildDescription(locale, theme, card, isCustom),
        ],
      ),
    );
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
                locale.translate('card.upload_image'),
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(AppLocalizations locale, ThemeData theme, CardEntity? card) {
    return ClipRRect(
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
              locale.translate('card.no_image'),
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(AppLocalizations locale, ThemeData theme, CardEntity? card, bool isCustom) {
    if (isCustom) {
      return Opacity(
        opacity: 0.6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Icon(Icons.edit_rounded),
          ],
        ),
      );
    }
    if (card == null) {
      return Container();
    }
    if (card.additionalData == null) {
      return _buildDescriptionText(
        theme,
        card.description ?? locale.translate('card.no_description'),
      );
    }
    return Opacity(
      opacity: 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: card.additionalData!.entries.map((entry) {
          final value = entry.value;
          if (value is String && value.isNotEmpty || value is num) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${entry.key}: ',
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: '$value',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            );
          }
          return const SizedBox();
        }).toList(),
      ),
    );
  }

  Widget _buildDescriptionText(ThemeData theme, String text) {
    return Opacity(
      opacity: 0.6,
      child: Text(
        text,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
