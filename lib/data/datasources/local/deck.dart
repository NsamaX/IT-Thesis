import 'package:nfc_project/core/services/sqlite.dart';
import '../../models/deck.dart';

abstract class DeckLocalDataSource {
  Future<void> saveDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
  Future<List<DeckModel>> loadDecks();
}

class DeckLocalDataSourceImpl implements DeckLocalDataSource {
  final SQLiteService _sqliteService;

  DeckLocalDataSourceImpl(this._sqliteService);

  @override
  Future<void> saveDeck(DeckModel deck) async {
    try {
      await _sqliteService.insert('decks', deck.toJson());
    } catch (e) {
      throw Exception('Failed to save deck: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    try {
      await _sqliteService.delete('decks', 'deckId', deckId);
    } catch (e) {
      throw Exception('Failed to delete deck with ID $deckId: ${e.toString()}');
    }
  }

  @override
  Future<List<DeckModel>> loadDecks() async {
    try {
      final decks = await _sqliteService.query('decks');
      return decks.map((deck) => DeckModel.fromJson(deck)).toList();
    } catch (e) {
      throw Exception('Failed to load decks: ${e.toString()}');
    }
  }
}
