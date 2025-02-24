import 'dart:convert';
import 'dart:collection';
import 'package:nfc_project/core/storage/sqlite.dart';
import '../../models/card.dart';

abstract class CardLocalDataSource {
  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน fetchCardById
   |
   |  วัตถุประสงค์:
   |      ดึงข้อมูลการ์ดจากฐานข้อมูลตาม ID และเกมที่ระบุ
   |
   |  พารามิเตอร์:
   |      game (IN) -- ชื่อเกมที่ต้องการค้นหา
   |      id (IN) -- รหัสของการ์ดที่ต้องการค้นหา
   |
   |  ค่าที่คืนกลับ:
   |      - ถ้าพบการ์ด คืนค่าเป็น `CardModel`
   |      - ถ้าไม่พบ คืนค่าเป็น `null`
   *--------------------------------------------------------------------------*/
  Future<CardModel?> fetchCardById(String game, String id);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน fetchCards
   |
   |  วัตถุประสงค์:
   |      ดึงข้อมูลการ์ดทั้งหมดจากฐานข้อมูลตามชื่อเกม
   |
   |  พารามิเตอร์:
   |      game (IN) -- ชื่อเกมที่ต้องการค้นหา
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น `List<CardModel>` ของการ์ดที่พบ
   *--------------------------------------------------------------------------*/
  Future<List<CardModel>> fetchCards(String game);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน fetchLastPage
   |
   |  วัตถุประสงค์:
   |      ดึงเลขหน้าล่าสุดที่ถูกบันทึกในฐานข้อมูล
   |
   |  พารามิเตอร์:
   |      game (IN) -- ชื่อเกมที่ต้องการค้นหา
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าหมายเลขหน้าล่าสุดเป็น `int`
   *--------------------------------------------------------------------------*/
  Future<int> fetchLastPage(String game);


  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน isPageExists
   |
   |  วัตถุประสงค์:
   |      ตรวจสอบว่าหมายเลขหน้าที่ระบุมีอยู่ในฐานข้อมูลหรือไม่
   |
   |  พารามิเตอร์:
   |      game (IN) -- ชื่อเกมที่ต้องการตรวจสอบ
   |      page (IN) -- หมายเลขหน้าที่ต้องการตรวจสอบ
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น `true` ถ้าหมายเลขหน้ามีอยู่
   |      - คืนค่าเป็น `false` ถ้าไม่พบ
   *--------------------------------------------------------------------------*/
  Future<bool> isPageExists(String game, int page);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน saveCards
   |
   |  วัตถุประสงค์:
   |      บันทึกข้อมูลการ์ดลงฐานข้อมูล และบันทึกหน้าที่เกี่ยวข้อง
   |
   |  พารามิเตอร์:
   |      game (IN) -- ชื่อเกมที่ต้องการบันทึก
   |      page (IN) -- หมายเลขหน้าที่ต้องการบันทึก
   |      cards (IN) -- รายการการ์ดที่ต้องการบันทึก
   *--------------------------------------------------------------------------*/
  Future<void> saveCards(String game, int page, List<CardModel> cards);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน clearCards
   |
   |  วัตถุประสงค์:
   |      ลบข้อมูลการ์ดและหมายเลขหน้าทั้งหมดของเกมที่ระบุออกจากฐานข้อมูล
   |
   |  พารามิเตอร์:
   |      game (IN) -- ชื่อเกมที่ต้องการลบข้อมูล
   |
   |  ค่าที่คืนกลับ:
   |      - ไม่มีค่าคืนกลับ (แต่ข้อมูลที่เกี่ยวข้องกับเกมจะถูกลบทั้งหมด)
   *--------------------------------------------------------------------------*/
  Future<void> clearCards(String game);
}

class CardLocalDataSourceImpl implements CardLocalDataSource {
  late final SQLiteService _sqliteService;

  static const String _cardsTable = 'cards';
  static const String _pagesTable = 'pages';
  static const String _columnId = 'id';
  static const String _columnGame = 'game';
  static const String _columnName = 'name';
  static const String _columnDescription = 'description';
  static const String _columnImageUrl = 'imageUrl';
  static const String _columnAdditionalData = 'additionalData';
  static const String _columnPage = 'page';

  CardLocalDataSourceImpl(this._sqliteService);

  @override
  Future<CardModel?> fetchCardById(String game, String id) async {
    final result = await _sqliteService.query(
      _cardsTable,
      where: '$_columnGame = ? AND $_columnId = ?',
      whereArgs: [game, id],
    );
    return result.isNotEmpty ? _parseCards(result).first : null;
  }

  @override
  Future<List<CardModel>> fetchCards(String game) async {
    final result = await _sqliteService.query(
      _cardsTable,
      where: '$_columnGame = ?',
      whereArgs: [game],
    );
    return UnmodifiableListView(_parseCards(result));
  }

  @override
  Future<int> fetchLastPage(String game) async {
    final result = await _sqliteService.query(
      _pagesTable,
      where: '$_columnGame = ?',
      whereArgs: [game],
    );
    return result.isNotEmpty ? (result.first[_columnPage] ?? 0) : 0;
  }

  @override
  Future<bool> isPageExists(String game, int page) async {
    final result = await _sqliteService.query(
      _pagesTable,
      where: '$_columnGame = ? AND $_columnPage = ?',
      whereArgs: [game, page],
    );
    return result.isNotEmpty;
  }

  @override
  Future<void> saveCards(String game, int page, List<CardModel> cards) async {
    final cardDataList = cards.map((card) => {
          _columnId: card.cardId,
          _columnGame: game,
          _columnName: card.name,
          _columnDescription: card.description,
          _columnImageUrl: card.imageUrl,
          _columnAdditionalData: json.encode(card.additionalData),
        }).toList();

    await Future.wait([
      _sqliteService.insertBatch(_cardsTable, cardDataList),
      _savePageIfNotExists(game, page),
    ]);
  }

  @override
  Future<void> clearCards(String game) async {
    final db = await _sqliteService.getDatabase();
    await db.transaction((txn) async {
      await txn.delete(_cardsTable, where: '$_columnGame = ?', whereArgs: [game]);
      await txn.delete(_pagesTable, where: '$_columnGame = ?', whereArgs: [game]);
    });
  }

  List<CardModel> _parseCards(List<Map<String, dynamic>> rows) =>
      rows.map((row) => CardModel(
            cardId: row[_columnId],
            game: row[_columnGame],
            name: row[_columnName],
            description: row[_columnDescription],
            imageUrl: row[_columnImageUrl],
            additionalData: json.decode(row[_columnAdditionalData] ?? '{}'),
          )).toList();

  Future<void> _savePageIfNotExists(String game, int page) async {
    if (!await isPageExists(game, page)) {
      await _sqliteService.insert(
        _pagesTable,
        {_columnGame: game, _columnPage: page},
      );
    }
  }
}
