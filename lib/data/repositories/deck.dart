import '../datasources/local/deck.dart';
import '../models/deck.dart';

abstract class DeckRepository {
  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน saveDeck
   |
   |  วัตถุประสงค์:
   |      บันทึกข้อมูล Deck ลงใน local storage
   |
   |  พารามิเตอร์:
   |      deck (IN) -- DeckModel ที่ต้องการบันทึก
   |
   |  ค่าที่คืนกลับ: Future<void>
   *--------------------------------------------------------------------------*/
  Future<void> saveDeck(DeckModel deck);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน deleteDeck
   |
   |  วัตถุประสงค์:
   |      ลบข้อมูล Deck ตาม deckId ที่ระบุ
   |
   |  พารามิเตอร์:
   |      deckId (IN) -- ID ของ Deck ที่ต้องการลบ
   |
   |  ค่าที่คืนกลับ: Future<void>
   *--------------------------------------------------------------------------*/
  Future<void> deleteDeck(String deckId);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน loadDecks
   |
   |  วัตถุประสงค์:
   |      ดึงข้อมูล Deck ทั้งหมดจาก local storage
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Future<List<DeckModel>> ที่มีรายการ Deck ทั้งหมด
   *--------------------------------------------------------------------------*/
  Future<List<DeckModel>> loadDecks();
}

class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDataSource datasource;

  DeckRepositoryImpl(this.datasource);

  @override
  Future<void> saveDeck(DeckModel deck) => datasource.saveDeck(deck);

  @override
  Future<void> deleteDeck(String deckId) => datasource.deleteDeck(deckId);

  @override
  Future<List<DeckModel>> loadDecks() => datasource.loadDecks();
}
