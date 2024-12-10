import 'package:flutter/material.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'card.dart';
import 'deck.dart';

class GridWidget extends StatelessWidget {
  final List<dynamic> items;

  const GridWidget({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return item is CardEntity
            ? CardWidget(card: item)
            : DeckWidget(deck: item);
      },
    );
  }
}
