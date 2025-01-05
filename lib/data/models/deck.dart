import 'dart:convert';
import 'card.dart';

class DeckModel {
  final String deckId, deckName;
  final Map<CardModel, int> cards;

  DeckModel({
    required this.deckId,
    required this.deckName,
    required this.cards,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    final cardsJson = json['cards'] as String;
    final decodedCards = jsonDecode(cardsJson) as Map<String, dynamic>;
    return DeckModel(
      deckId: json['deckId'] as String,
      deckName: json['deckName'] as String,
      cards: decodedCards.map(
        (key, value) {
          final cardJson = value['card'] as Map<String, dynamic>;
          return MapEntry(
            CardModel.fromJson(cardJson),
            value['count'] as int,
          );
        },
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deckId': deckId,
      'deckName': deckName,
      'cards': jsonEncode(cards.map(
        (key, value) => MapEntry(
          jsonEncode(key.toJson()),
          {'card': key.toJson(), 'count': value},
        ),
      )),
    };
  }
}
