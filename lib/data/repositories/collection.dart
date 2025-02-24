import '../datasources/local/collection.dart';
import '../models/card.dart';

abstract class CollectionRepository {
  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน addCardToCollection
   |
   |  วัตถุประสงค์:
   |      เพิ่มการ์ดเข้าไปในคลังสะสมของผู้ใช้
   |
   |  พารามิเตอร์:
   |      card (IN) -- CardModel ของการ์ดที่ต้องการเพิ่มเข้าไปในคลัง
   |
   |  ค่าที่คืนกลับ: Future<void>
   *--------------------------------------------------------------------------*/
  Future<void> addCardToCollection(CardModel card);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน removeCardFromCollection
   |
   |  วัตถุประสงค์:
   |      ลบการ์ดออกจากคลังสะสมของผู้ใช้
   |
   |  พารามิเตอร์:
   |      cardId (IN) -- ID ของการ์ดที่ต้องการลบออกจากคลัง
   |
   |  ค่าที่คืนกลับ: Future<void>
   *--------------------------------------------------------------------------*/
  Future<void> removeCardFromCollection(String cardId);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน fetchCollection
   |
   |  วัตถุประสงค์:
   |      ดึงรายการการ์ดทั้งหมดที่อยู่ในคลังสะสมของผู้ใช้
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Future<List<CardModel>> ที่มีรายการการ์ดทั้งหมด
   *--------------------------------------------------------------------------*/
  Future<List<CardModel>> fetchCollection();
}

class CollectionRepositoryImpl implements CollectionRepository {
  final CollectionLocalDataSource datasource;

  CollectionRepositoryImpl(this.datasource);

  @override
  Future<void> addCardToCollection(CardModel card) => datasource.addCardToCollection(card);

  @override
  Future<void> removeCardFromCollection(String cardId) => datasource.removeCardFromCollection(cardId);

  @override
  Future<List<CardModel>> fetchCollection() => datasource.fetchCollection();
}
