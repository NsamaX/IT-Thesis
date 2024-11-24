import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../core/locales/localizations.dart';
import '../../../domain/entities/card.dart';

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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(40),
      child: ListView(
        children: [
          isCustom
              ? _buildDottedBorder(context)
              : _buildCardImage(context, card),
          const SizedBox(height: 26),
          Text(
            AppLocalizations.of(context).translate('card_description'),
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _buildDescription(context, card, isCustom),
        ],
      ),
    );
  }

  Widget _buildDottedBorder(BuildContext context) {
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
                AppLocalizations.of(context).translate('upload_image'),
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardImage(
    BuildContext context,
    CardEntity? card,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: card?.imageUrl != null
            ? Image.network(
                card!.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildErrorImage(context),
              )
            : _buildErrorImage(context),
      ),
    );
  }

  Widget _buildErrorImage(BuildContext context) {
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
              AppLocalizations.of(context).translate('no_card_image'),
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(
    BuildContext context,
    CardEntity? card,
    bool isCustom,
  ) {
    final theme = Theme.of(context);
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
      return _buildDescriptionText(
        context,
        AppLocalizations.of(context).translate('no_card_info'),
      );
    }

    if (card.additionalData == null) {
      return _buildDescriptionText(
        context,
        card.description ??
            AppLocalizations.of(context).translate('no_card_description'),
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

  Widget _buildDescriptionText(
    BuildContext context,
    String text,
  ) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: 0.6,
      child: Text(
        text,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
