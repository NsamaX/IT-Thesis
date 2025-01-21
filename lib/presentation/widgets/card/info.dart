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
        _buildTitle(locale, theme),
        const SizedBox(height: 8.0),
        _buildDescription(locale, theme),
      ],
    );
  }

  Widget _buildTitle(AppLocalizations locale, ThemeData theme) {
    final title = isCustom
        ? locale.translate('text.description')
        : card?.name ?? locale.translate('text.no_card_name');

    return Text(
      title,
      style: theme.textTheme.titleSmall,
    );
  }

  Widget _buildDescription(AppLocalizations locale, ThemeData theme) {
    if (isCustom) return _buildEditableHint();
    if (card == null) return const SizedBox.shrink();
    return card?.additionalData != null
        ? _buildAdditionalData(theme, card!.additionalData!)
        : _buildDefaultDescription(locale, theme, card!);
  }

  Widget _buildEditableHint() => Opacity(
    opacity: 0.6,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        Icon(Icons.edit_rounded),
      ],
    ),
  );

  Widget _buildAdditionalData(ThemeData theme, Map<String, dynamic> additionalData) {
    final List<Widget> dataEntries = additionalData.entries.map((entry) {
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
      return const SizedBox.shrink();
    }).toList();
    return Opacity(
      opacity: 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dataEntries,
      ),
    );
  }

  Widget _buildDefaultDescription(AppLocalizations locale, ThemeData theme, CardEntity card) => Opacity(
    opacity: 0.6,
    child: Text(
      card.description ?? locale.translate('text.no_card_description'),
      style: theme.textTheme.bodyMedium,
    ),
  );
}
