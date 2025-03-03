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
    Key? key,
    this.card,
    required this.descriptionController,
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
        isCustom ? _buildEditableDescription(context, theme) : _buildDescription(locale, theme),
      ],
    );
  }

  /// The title (either description or card name)
  Widget _buildTitle(AppLocalizations locale, ThemeData theme) {
    final title = isCustom
        ? locale.translate('text.description')
        : card?.name ?? locale.translate('text.no_card_name');

    return Text(
      title,
      style: theme.textTheme.titleSmall,
    );
  }

  /// Editable description for custom cards
  Widget _buildEditableDescription(BuildContext context, ThemeData theme) {
    final collectionCubit = context.watch<CollectionCubit>();

    return Opacity(
      opacity: 0.8,
      child: TextField(
        controller: descriptionController,
        textAlign: TextAlign.start,
        maxLines: null,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "...",
          isDense: true,
        ),
        onChanged: (text) {
          collectionCubit.setDescription(text);
        },
      ),
    );
  }

  /// Description based on whether it's custom or not
  Widget _buildDescription(AppLocalizations locale, ThemeData theme) {
    if (card != null) {
      return card?.additionalData != null
          ? _buildAdditionalData(theme, card!.additionalData!)
          : _buildDefaultDescription(locale, theme, card!);
    }
    return const SizedBox.shrink();
  }

  /// Display additional data if available
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

  /// Default description if no additional data
  Widget _buildDefaultDescription(AppLocalizations locale, ThemeData theme, CardEntity card) {
    return Opacity(
      opacity: 0.6,
      child: Text(
        card.description ?? locale.translate('text.no_card_description'),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
