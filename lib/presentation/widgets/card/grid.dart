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
    final bool isCard = items.every((element) => element is MapEntry<CardEntity, int>);
    final double spacing = isCard ? 8 : 12;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: isCard ? 3 / 4 : 1,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        if (isCard) {
          final cardEntry = item as MapEntry<CardEntity, int>;
          return CardWidget(card: cardEntry.key, count: cardEntry.value);
        } else {
          return DeckWidget(deck: item as DeckEntity);
        }
      },
    );
  }
}
