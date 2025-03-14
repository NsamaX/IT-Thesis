import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';

import 'package:nfc_project/domain/entities/card.dart';

import '../../cubits/collection.dart';

class CardInfoWidget extends StatelessWidget {
  final CardEntity? card;
  final bool isCustom;
  final TextEditingController descriptionController;

  const CardInfoWidget({
    super.key,
    this.card,
    required this.descriptionController,
    this.isCustom = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(locale, theme),
        const SizedBox(height: 8.0),
        isCustom ? _buildEditableDescription(context, theme) : _buildDescription(locale, theme),
      ],
    );
  }

  Widget _buildTitle(
    AppLocalizations locale, 
    ThemeData theme,
  ) {
    final String title = isCustom
        ? locale.translate('text.description')
        : card?.name ?? locale.translate('text.no_card_name');

    return Text(title, style: theme.textTheme.titleSmall);
  }

  Widget _buildEditableDescription(
    BuildContext context, 
    ThemeData theme,
  ) {
    return Opacity(
      opacity: 0.8,
      child: TextField(
        controller: descriptionController,
        textAlign: TextAlign.start,
        maxLines: null,
        style: theme.textTheme.bodyMedium,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "...",
          isDense: true,
        ),
        onChanged: context.read<CollectionCubit>().setDescription,
      ),
    );
  }

  Widget _buildDescription(
    AppLocalizations locale, 
    ThemeData theme,
  ) {
    if (card == null) return const SizedBox.shrink();

    return card!.additionalData != null
        ? _buildAdditionalData(theme, card!.additionalData!)
        : _buildDefaultDescription(locale, theme, card!);
  }

  Widget _buildAdditionalData(
    ThemeData theme, 
    Map<String, dynamic> additionalData,
  ) {
    final List<Widget> dataEntries = additionalData.entries
        .where((entry) => (entry.value is String && entry.value.isNotEmpty) || entry.value is num)
        .map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: '${entry.key}: ', style: theme.textTheme.bodyMedium),
                    TextSpan(text: '${entry.value}', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ))
        .toList();

    return Opacity(
      opacity: 0.6,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: dataEntries),
    );
  }

  Widget _buildDefaultDescription(
    AppLocalizations locale, 
    ThemeData theme, 
    CardEntity card,
  ) {
    return Opacity(
      opacity: 0.6,
      child: Text(
        card.description ?? locale.translate('text.no_card_description'),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
