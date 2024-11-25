import 'card.dart';

class DeckEntity {
  final String deckId;
  final String deckName;
  final Map<CardEntity, int> cards;

  DeckEntity({
    required this.deckId,
    required this.deckName,
    required this.cards,
  });

  int get totalCards => cards.values.fold(0, (total, count) => total + count);
  List<String> get games {
    return cards.keys.map((card) => card.game).toSet().toList();
  }

  DeckEntity copyWith({
    String? deckId,
    String? deckName,
    Map<CardEntity, int>? cards,
  }) {
    return DeckEntity(
      deckId: deckId ?? this.deckId,
      deckName: deckName ?? this.deckName,
      cards: cards ?? this.cards,
    );
  }
}
