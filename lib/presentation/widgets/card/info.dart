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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        const SizedBox(height: 8.0),
        _buildDescription(context),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, ) {
    final locale = AppLocalizations.of(context);
    return Text(
      card == null ? locale.translate('text.no_card_name') : card!.name,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  Widget _buildDescription(BuildContext context) {
    if (isCustom) return _buildEditable();
    if (card == null) return const SizedBox();
    if (card!.additionalData != null) return _buildAdditionalData(context);
    return _buildNoAdditionalData(context, card: card!);
  }

  Widget _buildEditable() {
    return const Opacity(
      opacity: 0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.edit_rounded),
        ],
      ),
    );
  }

  Widget _buildAdditionalData(BuildContext context) {
    final additionalData = card?.additionalData;
    if (additionalData == null) return const SizedBox();
    final theme = Theme.of(context);
    return Opacity(
      opacity: 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: additionalData.entries.map((entry) {
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

  Widget _buildNoAdditionalData(
    BuildContext context, {
    required CardEntity card,
  }) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Opacity(
      opacity: 0.6,
      child: Text(
        card.description ?? locale.translate('text.no_card_description'),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
