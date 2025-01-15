import 'package:nfc_project/core/services/sqlite.dart';
import '../../models/deck.dart';

abstract class DeckLocalDataSource {
  Future<void> saveDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
  Future<List<DeckModel>> loadDecks();
}

class DeckLocalDataSourceImpl implements DeckLocalDataSource {
  final SQLiteService _sqliteService;

  static const String decksTable = 'decks';
  static const String columnDeckId = 'deckId';

  DeckLocalDataSourceImpl(this._sqliteService);

  @override
  Future<void> saveDeck(DeckModel deck) async {
    await _sqliteService.insert(decksTable, deck.toJson());
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    await _sqliteService.delete(decksTable, columnDeckId, deckId);
  }

  @override
  Future<List<DeckModel>> loadDecks() async {
    final decks = await _sqliteService.query(decksTable);
    return decks.map((deck) => DeckModel.fromJson(deck)).toList();
  }
}
