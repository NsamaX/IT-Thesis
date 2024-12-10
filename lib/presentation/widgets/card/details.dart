import 'package:flutter/material.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.translate('card.card_description'),
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        _buildDescription(locale, theme),
      ],
    );
  }

  Widget _buildDescription(AppLocalizations locale, ThemeData theme) {
    if (isCustom) {
      return _buildEditableDescription();
    }
    if (card == null) {
      return Container();
    }
    if (card!.additionalData == null) {
      return _buildDescriptionText(
        theme,
        card!.description ?? locale.translate('card.no_description'),
      );
    }
    return _buildAdditionalDataDescription(theme);
  }

  Widget _buildEditableDescription() {
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

  Widget _buildAdditionalDataDescription(ThemeData theme) {
    return Opacity(
      opacity: 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: card!.additionalData!.entries.map((entry) {
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
      child: Text(text, style: theme.textTheme.bodyMedium),
    );
  }
}
