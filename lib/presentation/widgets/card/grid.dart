import 'package:flutter/material.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import 'card.dart';
import 'deck.dart';

class GridWidget extends StatelessWidget {
  final List<dynamic> items;

  const GridWidget({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDeckEntity = items.isNotEmpty && items.first is DeckEntity;
    final bool isCardEntity = items.isNotEmpty && items.first is CardEntity;
    final double spacing = isDeckEntity ? 12 : 8;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: isDeckEntity ? 1 : 3 / 4,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
         if (isDeckEntity) {
          return DeckWidget(deck: item as DeckEntity);
        } else if (isCardEntity) {
          final card = item as CardEntity;
          return CardWidget(card: card);
        } else {
          final cardEntry = item as MapEntry<CardEntity, int>;
          return CardWidget(card: cardEntry.key, count: cardEntry.value);
        }
      },
    );
  }
}
