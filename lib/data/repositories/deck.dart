import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/deck.dart';

class DeckRepository {
  static const String _deckKey = "user_decks";
  Future<Map<String, dynamic>> getDecks() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDecks = prefs.getString(_deckKey);
    if (storedDecks != null) {
      return Map<String, dynamic>.from(jsonDecode(storedDecks));
    }
    return {};
  }

  Future<void> saveDeck(DeckModel deck) async {
    final prefs = await SharedPreferences.getInstance();
    final decks = await getDecks();
    final serializedCards = deck.cards.map(
      (key, value) => MapEntry(key.cardId, {
        'card': key.toJson(),
        'count': value,
      }),
    );
    final deckData = {
      'deckId': deck.deckId,
      'deckName': deck.deckName,
      'cards': serializedCards,
    };
    decks[deck.deckId] = deckData;
    await prefs.setString(_deckKey, jsonEncode(decks));
  }

  Future<void> deleteDeck(String deckId) async {
    final prefs = await SharedPreferences.getInstance();
    final decks = await getDecks();
    decks.remove(deckId);
    await prefs.setString(_deckKey, jsonEncode(decks));
  }
}
