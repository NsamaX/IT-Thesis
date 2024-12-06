import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nfc_project/core/utils/exceptions.dart';
import '../../models/deck.dart';

abstract class DeckLocalDataSource {
  Future<List<DeckModel>> getDecks();
  Future<void> saveDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
}

class DeckLocalDataSourceImpl implements DeckLocalDataSource {
  static const String _deckKey = "user_decks";

  @override
  Future<List<DeckModel>> getDecks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedDecks = prefs.getString(_deckKey);
      if (storedDecks != null) {
        final decksData = Map<String, dynamic>.from(jsonDecode(storedDecks));
        return decksData.values
            .map((deck) => DeckModel.fromJson(deck))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to load decks: ${e.runtimeType} - ${e.toString()}');
    }
  }

  @override
  Future<void> saveDeck(DeckModel deck) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final decks = await getDecks();
      final updatedDecks = {
        for (var existingDeck in decks) existingDeck.deckId: existingDeck.toJson(),
        deck.deckId: deck.toJson(),
      };
      await prefs.setString(_deckKey, jsonEncode(updatedDecks));
    } catch (e) {
      throw CacheException('Failed to save deck: ${e.runtimeType} - ${e.toString()}');
    }
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final decks = await getDecks();
      final updatedDecks = decks.where((deck) => deck.deckId != deckId).toList();
      final serializedDecks = {
        for (var deck in updatedDecks) deck.deckId: deck.toJson(),
      };
      await prefs.setString(_deckKey, jsonEncode(serializedDecks));
    } catch (e) {
      throw CacheException('Failed to delete deck: ${e.runtimeType} - ${e.toString()}');
    }
  }
}
