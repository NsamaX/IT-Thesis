import 'card.dart';

class DeckModel {
  final String deckId;
  final String deckName;
  final Map<CardModel, int> cards;

  DeckModel({
    required this.deckId,
    required this.deckName,
    required this.cards,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      deckId: json['deckId'] as String,
      deckName: json['deckName'] as String,
      cards: (json['cards'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          CardModel.fromJson(key as Map<String, dynamic>),
          value as int,
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deckId': deckId,
      'deckName': deckName,
      'cards': cards.map(
        (key, value) => MapEntry(key.toJson(), value),
      ),
    };
  }
}
