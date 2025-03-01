import 'package:nfc_project/core/storage/sqlite.dart';

import '../../models/deck.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
abstract class DeckLocalDataSource {
  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> saveDeck(DeckModel deck);

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> deleteDeck(String deckId);

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<List<DeckModel>> loadDecks();
}

class DeckLocalDataSourceImpl implements DeckLocalDataSource {
  final SQLiteService _sqliteService;

  static const String _decksTable = 'decks';
  static const String _columnDeckId = 'deckId';

  DeckLocalDataSourceImpl(this._sqliteService);

  @override
  Future<void> saveDeck(DeckModel deck) async {
    await _sqliteService.insert(_decksTable, deck.toJson());
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    await _sqliteService.delete(_decksTable, _columnDeckId, deckId);
  }

  @override
  Future<List<DeckModel>> loadDecks() async {
    final decks = await _sqliteService.query(_decksTable);
    return decks.map((deck) => DeckModel.fromJson(deck)).toList();
  }
}
