import 'card.dart';

class DeckModel {
  final String deckId;
  final String deckName;
  final List<CardModel> cards;

  DeckModel({
    required this.deckId,
    required this.deckName,
    required this.cards,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      deckId: json['deckId'] as String,
      deckName: json['deckName'] as String,
      cards: (json['cards'] as List<dynamic>?)
              ?.map((card) => CardModel.fromJson(card as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deckId': deckId,
      'deckName': deckName,
      'cards': cards.map((card) => card.toJson()).toList(),
    };
  }
}
