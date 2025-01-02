import 'package:nfc_project/core/services/sqlite.dart';
import '../../models/deck.dart';

abstract class DeckLocalDataSource {
  /// ดึงรายการสำรับทั้งหมดที่บันทึกไว้
  Future<List<DeckModel>> loadDecks();

  /// บันทึกข้อมูลสำรับใหม่หรืออัปเดตสำรับเดิม
  Future<void> saveDeck(DeckModel deck);

  /// ลบข้อมูลสำรับที่ระบุด้วย deckId
  Future<void> deleteDeck(String deckId);
}

class DeckLocalDataSourceImpl implements DeckLocalDataSource {
  final SQLiteService _sqliteService;

  DeckLocalDataSourceImpl(this._sqliteService);

  @override
  Future<List<DeckModel>> loadDecks() async {
    final decks = await _sqliteService.query('decks');
    return decks.map((deck) => DeckModel.fromJson(deck)).toList();
  }

  @override
  Future<void> saveDeck(DeckModel deck) async {
    await _sqliteService.insert('decks', deck.toJson());
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    await _sqliteService.delete('decks', 'deckId', deckId);
  }
}
