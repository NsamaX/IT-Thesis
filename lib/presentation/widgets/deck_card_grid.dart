import 'package:flutter/material.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import 'card.dart';
import 'deck.dart';

class DeckCardGridWidget extends StatelessWidget {
  final List<dynamic> items;

  const DeckCardGridWidget({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return Container();
    final itemType = _getItemType(items.first);
    final gridConfig = _getGridConfig(itemType);
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: gridConfig['spacing'] as double,
        crossAxisSpacing: gridConfig['spacing'] as double,
        childAspectRatio: gridConfig['aspectRatio'] as double,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildGridItem(
        items[index],
        itemType,
      ),
    );
  }

  String _getItemType(dynamic item) {
    if (item is DeckEntity) return 'deck';
    if (item is CardEntity) return 'card';
    if (item is MapEntry<CardEntity, int>) return 'cardWithCount';
    return 'unknown';
  }

  Map<String, double> _getGridConfig(String itemType) => {
    'deck': {'spacing': 12.0, 'aspectRatio': 1.0},
  }[itemType] ?? {'spacing': 8.0, 'aspectRatio': 3 / 4};

  Widget _buildGridItem(dynamic item, String itemType) {
    switch (itemType) {
      case 'deck':
        return DeckWidget(deck: item as DeckEntity);
      case 'card':
        return CardWidget(card: item as CardEntity);
      case 'cardWithCount':
        final cardEntry = item as MapEntry<CardEntity, int>;
        return CardWidget(card: cardEntry.key, count: cardEntry.value);
      default:
        return const Center(child: Text('Unsupported item type'));
    }
  }
}
