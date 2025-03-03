import 'package:flutter/material.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/card.dart';

import 'labels/card.dart';

class CardListWidget extends StatelessWidget {
  final List<CardEntity> cards;
  final bool isAdd;
  final bool isCustom;
  final void Function(String cardId)? onDelete;

  const CardListWidget({
    Key? key,
    required this.cards,
    this.isAdd = false,
    this.isCustom = false,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context).translate('text.no_results')),
      );
    }

    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) => CardLabelWidget(
        card: cards[index],
        isAdd: isAdd,
        isCustom: isCustom,
        onDelete: onDelete,
      ),
      cacheExtent: 1000,
    );
  }
}
