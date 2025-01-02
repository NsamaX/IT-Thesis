import 'dart:convert';
import 'package:nfc_project/core/services/sqlite.dart';
import '../../models/card.dart';

abstract class CardLocalDataSource {
  /// ดึงรายการการ์ดทั้งหมดสำหรับเกมที่ระบุ
  Future<List<CardModel>> fetchCards(String game);

  /// ดึงหน้าสุดท้ายที่บันทึกไว้ของเกมที่ระบุ
  Future<int> fetchLastPage(String game);

  /// ตรวจสอบว่าหน้าของเกมที่ระบุมีอยู่หรือไม่
  Future<bool> isPageExists(String game, int page);

  /// บันทึกรายการการ์ดสำหรับเกมและหน้าที่ระบุ
  Future<void> saveCards(String game, int page, List<CardModel> cards);

  /// ลบการ์ดทั้งหมดที่เกี่ยวข้องกับเกมที่ระบุ
  Future<void> clearCards(String game);
}

class CardLocalDataSourceImpl implements CardLocalDataSource {
  final SQLiteService _sqliteService;

  CardLocalDataSourceImpl(this._sqliteService);

  List<CardModel> _parseCards(List<Map<String, dynamic>> rows) {
    return rows.map((row) {
      try {
        return CardModel(
          cardId: row['id'],
          game: row['game'],
          name: row['name'],
          description: row['description'],
          imageUrl: row['imageUrl'],
          additionalData: json.decode(row['additionalData'] ?? '{}'),
        );
      } catch (e) {
        return CardModel(
          cardId: row['id'],
          game: row['game'],
          name: row['name'],
          description: row['description'],
          imageUrl: row['imageUrl'],
          additionalData: {},
        );
      }
    }).toList();
  }

  @override
  Future<List<CardModel>> fetchCards(String game) async {
    final result = await _sqliteService.query('cards', where: 'game = ?', whereArgs: [game]);
    return _parseCards(result);
  }

  @override
  Future<int> fetchLastPage(String game) async {
    final result = await _sqliteService.query('pages', where: 'game = ?', whereArgs: [game]);
    final pageData = result.firstWhere(
      (row) => row['game'] == game,
      orElse: () => {'page': 0},
    );
    return pageData['page'] ?? 0;
  }

  Future<bool> isPageExists(String game, int page) async {
    final db = await _sqliteService.getDatabase();
    final result = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM pages WHERE game = ? AND page = ? LIMIT 1)',
      [game, page],
    );
    return result.first.values.first == 1;
  }

  Future<void> _savePageIfNotExists(String game, int page) async {
    if (!await isPageExists(game, page)) {
      await _sqliteService.insert('pages', {
        'game': game,
        'page': page,
      });
    }
  }

  @override
  Future<void> saveCards(String game, int page, List<CardModel> cards) async {
    final cardDataList = cards.map((card) => {
          'id': card.cardId,
          'game': game,
          'name': card.name,
          'description': card.description,
          'imageUrl': card.imageUrl,
          'additionalData': json.encode(card.additionalData),
        }).toList();
    await Future.wait([
      _sqliteService.insertBatch('cards', cardDataList),
      _savePageIfNotExists(game, page),
    ]);
  }

  Future<void> clearCards(String game) async {
    final db = await _sqliteService.getDatabase();
    await db.transaction((txn) async {
      await txn.delete('cards', where: 'game = ?', whereArgs: [game]);
      await txn.delete('pages', where: 'game = ?', whereArgs: [game]);
    });
  }
}
