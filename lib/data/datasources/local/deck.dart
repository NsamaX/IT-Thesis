import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_project/core/utils/exceptions.dart';
import '../../models/deck.dart';

abstract class DeckLocalDataSource {
  Future<List<DeckModel>> loadDecks();
  Future<void> saveDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
}

class DeckLocalDataSourceImpl implements DeckLocalDataSource {
  static const String _deckKey = "decks";

  final SharedPreferences sharedPreferences;

  DeckLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<DeckModel>> loadDecks() async {
    try {
      final storedDecks = sharedPreferences.getString(_deckKey);
      if (storedDecks != null) {
        final decksData = Map<String, dynamic>.from(jsonDecode(storedDecks));
        return decksData.values.map((deck) {
          return DeckModel.fromJson(deck);
        }).toList();
      }
      return [];
    } catch (e) {
      throw LocalDataException('Failed to load decks', details: e.toString());
    }
  }

  @override
  Future<void> saveDeck(DeckModel deck) async {
    try {
      final decks = await loadDecks();
      final updatedDecks = {
        for (var existingDeck in decks) existingDeck.deckId: existingDeck.toJson(),
        deck.deckId: deck.toJson(),
      };
      await sharedPreferences.setString(_deckKey, jsonEncode(updatedDecks));
    } catch (e) {
      throw LocalDataException('Failed to save deck', details: e.toString());
    }
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    try {
      final decks = await loadDecks();
      final updatedDecks = decks.where((deck) => deck.deckId != deckId).toList();
      final serializedDecks = {
        for (var deck in updatedDecks) deck.deckId: deck.toJson(),
      };
      await sharedPreferences.setString(_deckKey, jsonEncode(serializedDecks));
    } catch (e) {
      throw LocalDataException('Failed to delete deck', details: e.toString());
    }
  }
}
