import 'package:nfc_project/core/storage/sqlite.dart';
import '../../models/deck.dart';

abstract class DeckLocalDataSource {
  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน saveDeck
   |
   |  วัตถุประสงค์:
   |      บันทึกข้อมูล Deck ลงในฐานข้อมูล
   |
   |  พารามิเตอร์:
   |      deck (IN) -- DeckModel ที่ต้องการบันทึก
   |
   |  ค่าที่คืนกลับ: ไม่มีค่าคืนกลับ (เป็น Future<void>)
   *--------------------------------------------------------------------------*/
  Future<void> saveDeck(DeckModel deck);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน deleteDeck
   |
   |  วัตถุประสงค์:
   |      ลบข้อมูล Deck ออกจากฐานข้อมูลโดยใช้ deckId
   |
   |  พารามิเตอร์:
   |      deckId (IN) -- ID ของ Deck ที่ต้องการลบ
   |
   |  ค่าที่คืนกลับ: ไม่มีค่าคืนกลับ (เป็น Future<void>)
   *--------------------------------------------------------------------------*/
  Future<void> deleteDeck(String deckId);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน loadDecks
   |
   |  วัตถุประสงค์:
   |      ดึงข้อมูล Deck ทั้งหมดจากฐานข้อมูล
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Future<List<DeckModel>> ที่มีรายการ Deck ทั้งหมด
   *--------------------------------------------------------------------------*/
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
