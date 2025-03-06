import 'package:flutter/material.dart';

import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/deck.dart';

import '../card/card.dart';
import 'deck.dart';

class DeckCardGridWidget extends StatelessWidget {
  final List<dynamic> items;

  const DeckCardGridWidget({
    super.key, 
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox();

    final String itemType = _getItemType(items.first);
    final Map<String, double> gridConfig = _getGridConfig(itemType);

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: gridConfig['spacing']!,
        crossAxisSpacing: gridConfig['spacing']!,
        childAspectRatio: gridConfig['aspectRatio']!,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildGridItem(items[index], itemType),
    );
  }

  String _getItemType(
    dynamic item,
  ) {
    if (item is DeckEntity) return 'deck';
    if (item is CardEntity) return 'card';
    if (item is MapEntry<CardEntity, int>) return 'cardWithCount';
    return 'unknown';
  }

  Map<String, double> _getGridConfig(
    String itemType,
  ) {
    return switch (itemType) {
      'deck' => {'spacing': 12.0, 'aspectRatio': 1.0},
      _ => {'spacing': 8.0, 'aspectRatio': 3 / 4}
    };
  }

  Widget _buildGridItem(
    dynamic item, 
    String itemType,
  ) {
    return switch (itemType) {
      'deck' => DeckWidget(deck: item as DeckEntity),
      'card' => CardWidget(card: item as CardEntity),
      'cardWithCount' => CardWidget(
          card: (item as MapEntry<CardEntity, int>).key,
          count: item.value,
        ),
      _ => const SizedBox()
    };
  }
}
