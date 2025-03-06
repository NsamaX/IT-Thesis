import 'package:flutter/material.dart';

import 'package:nfc_project/core/locales/localizations.dart';

import 'package:nfc_project/domain/entities/card.dart';

import '../shared/card_label.dart';

class CardListWidget extends StatelessWidget {
  final List<CardEntity> cards;
  final bool isAdd;
  final bool isCustom;
  final void Function(String cardId)? onDelete;

  const CardListWidget({
    super.key,
    required this.cards,
    this.isAdd = false,
    this.isCustom = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String noResultsText = AppLocalizations.of(context).translate('text.no_results');

    return cards.isEmpty
        ? _buildNoResults(noResultsText)
        : _buildListView();
  }

  Widget _buildNoResults(
    String text,
  ) {
    return Center(
      child: Text(text, style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: cards.length,
      itemBuilder: (context, index) => CardLabelWidget(
        card: cards[index],
        isAdd: isAdd,
        isCustom: isCustom,
        onDelete: onDelete,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 2.0),
      cacheExtent: 1000,
    );
  }
}
