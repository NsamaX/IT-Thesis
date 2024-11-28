import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/deck.dart';

abstract class DeckLocalDataSource {
  Future<Map<String, dynamic>> getDecks();
  Future<void> saveDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
}

class DeckLocalDataSourceImpl implements DeckLocalDataSource {
  static const String _deckKey = "user_decks";

  @override
  Future<Map<String, dynamic>> getDecks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedDecks = prefs.getString(_deckKey);
      if (storedDecks != null) {
        return Map<String, dynamic>.from(jsonDecode(storedDecks));
      }
      return {};
    } catch (e) {
      throw Exception('Failed to load decks: $e');
    }
  }

  @override
  Future<void> saveDeck(DeckModel deck) async {
    try {
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
    } catch (e) {
      throw Exception('Failed to save deck: $e');
    }
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final decks = await getDecks();
      if (!decks.containsKey(deckId)) {
        throw Exception('Deck with ID $deckId not found.');
      }
      decks.remove(deckId);
      await prefs.setString(_deckKey, jsonEncode(decks));
    } catch (e) {
      throw Exception('Failed to delete deck: $e');
    }
  }
}
