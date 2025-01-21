import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'labels/card.dart';

class CardListWidget extends StatelessWidget {
  final List<CardEntity> cards;
  final bool isAdd;
  final bool isCustom;

  const CardListWidget({
    Key? key,
    required this.cards,
    this.isAdd = false,
    this.isCustom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => cards.isEmpty
      ? Center(
          child: Text(AppLocalizations.of(context).translate('text.no_results')),
        )
      : ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) => CardLabelWidget(
            card: cards[index],
            isAdd: isAdd,
            isCustom: isCustom,
          ),
          cacheExtent: 1000,
        );
}
