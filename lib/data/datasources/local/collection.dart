import 'dart:convert';
import 'package:nfc_project/core/storage/sqlite.dart';
import '../../models/card.dart';

abstract class CollectionLocalDataSource {
  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน addCardToCollection
   |
   |  วัตถุประสงค์:
   |      เพิ่มการ์ดลงในฐานข้อมูลคอลเลกชัน
   |
   |  พารามิเตอร์:
   |      card (IN) -- CardModel ที่ต้องการเพิ่มลงในคอลเลกชัน
   |
   |  ค่าที่คืนกลับ: ไม่มีค่าคืนกลับ (เป็น Future<void>)
   *--------------------------------------------------------------------------*/
  Future<void> addCardToCollection(CardModel card);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน removeCardFromCollection
   |
   |  วัตถุประสงค์:
   |      ลบการ์ดออกจากฐานข้อมูลคอลเลกชันโดยใช้ cardId
   |
   |  พารามิเตอร์:
   |      cardId (IN) -- ID ของการ์ดที่ต้องการลบ
   |
   |  ค่าที่คืนกลับ: ไม่มีค่าคืนกลับ (เป็น Future<void>)
   *--------------------------------------------------------------------------*/
  Future<void> removeCardFromCollection(String cardId);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน fetchCollection
   |
   |  วัตถุประสงค์:
   |      ดึงรายการการ์ดทั้งหมดที่ถูกเก็บไว้ในคอลเลกชัน
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Future<List<CardModel>> ที่มีรายการการ์ดทั้งหมด
   *--------------------------------------------------------------------------*/
  Future<List<CardModel>> fetchCollection();
}

class CollectionLocalDataSourceImpl implements CollectionLocalDataSource {
  final SQLiteService _sqliteService;

  static const String _collectionTable = 'collections';
  static const String _columnCollectId = 'collectId';
  static const String _columnCard = 'card';

  CollectionLocalDataSourceImpl(this._sqliteService);

  @override
  Future<void> addCardToCollection(CardModel card) async {
    final cardData = json.encode(card.toJson());
    await _sqliteService.insert(
      _collectionTable,
      {
        _columnCollectId: card.cardId,
        _columnCard: cardData,
      },
    );
  }

  @override
  Future<void> removeCardFromCollection(String cardId) async {
    await _sqliteService.delete(
      _collectionTable,
      _columnCollectId,
      cardId,
    );
  }

  @override
  Future<List<CardModel>> fetchCollection() async {
    final result = await _sqliteService.query(_collectionTable);
    return result.map((row) {
      final Map<String, dynamic> cardData = json.decode(row[_columnCard]);
      return CardModel.fromJson(cardData);
    }).toList();
  }
}
