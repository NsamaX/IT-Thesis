import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/card.dart';

class CardInfoWidget extends StatelessWidget {
  final CardEntity? card;
  final bool isCustom;

  const CardInfoWidget({
    Key? key,
    this.card,
    this.isCustom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          card?.name ?? locale.translate('text.description'),
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        _buildDescription(context),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    final locale = AppLocalizations.of(context);

    if (isCustom) return _buildEditableDescription();
    if (card == null) return const SizedBox();
    if (card!.additionalData != null) return _buildAdditionalDataDescription(context);

    return _buildDescriptionText(
      context,
      card!.description ?? locale.translate('text.no_card_description'),
    );
  }

  Widget _buildEditableDescription() {
    return const Opacity(
      opacity: 0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.edit_rounded),
        ],
      ),
    );
  }

  Widget _buildAdditionalDataDescription(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: card!.additionalData!.entries.map((entry) {
          final value = entry.value;
          if ((value is String && value.isNotEmpty) || value is num) {
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
              ),
            );
          }
          return const SizedBox();
        }).toList(),
      ),
    );
  }

  Widget _buildDescriptionText(BuildContext context, String text) {
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
