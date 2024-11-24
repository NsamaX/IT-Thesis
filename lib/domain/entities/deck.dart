import 'card.dart';

class DeckEntity {
  final String deckId;
  final String deckName;
  final List<CardEntity> cards;

  DeckEntity({
    required this.deckId,
    required this.deckName,
    required this.cards,
  });

  DeckEntity copyWith({
    String? deckId,
    String? deckName,
    List<CardEntity>? cards,
  }) {
    return DeckEntity(
      deckId: deckId ?? this.deckId,
      deckName: deckName ?? this.deckName,
      cards: cards ?? this.cards,
    );
  }
}
