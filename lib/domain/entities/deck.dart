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
