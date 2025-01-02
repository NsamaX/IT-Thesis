import '../datasources/local/deck.dart';
import '../models/deck.dart';

abstract class DeckRepository {
  /// ดึงรายการสำรับทั้งหมดจาก Local Data Source
  Future<List<DeckModel>> loadDecks();

  /// บันทึกข้อมูลสำรับใหม่หรืออัปเดตสำรับเดิมใน Local Data Source
  Future<void> saveDeck(DeckModel deck);

  /// ลบข้อมูลสำรับที่ระบุด้วย `deckId` จาก Local Data Source
  Future<void> deleteDeck(String deckId);
}

class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDataSource localDataSource;

  DeckRepositoryImpl(this.localDataSource);

  @override
  Future<List<DeckModel>> loadDecks() async {
    return await localDataSource.loadDecks();
  }

  @override
  Future<void> saveDeck(DeckModel deck) async {
    await localDataSource.saveDeck(deck);
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    await localDataSource.deleteDeck(deckId);
  }
}
