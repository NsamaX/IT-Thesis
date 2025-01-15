import 'dart:convert';
import 'package:nfc_project/core/services/sqlite.dart';
import '../../models/card.dart';

abstract class CardLocalDataSource {
  Future<CardModel?> fetchCardById(String game, String id);
  Future<List<CardModel>> fetchCards(String game);
  Future<int> fetchLastPage(String game);
  Future<bool> isPageExists(String game, int page);
  Future<void> saveCards(String game, int page, List<CardModel> cards);
  Future<void> clearCards(String game);
}

class CardLocalDataSourceImpl implements CardLocalDataSource {
  final SQLiteService _sqliteService;

  static const String cardsTable = 'cards';
  static const String pagesTable = 'pages';

  static const String columnId = 'id';
  static const String columnGame = 'game';
  static const String columnName = 'name';
  static const String columnDescription = 'description';
  static const String columnImageUrl = 'imageUrl';
  static const String columnAdditionalData = 'additionalData';
  static const String columnPage = 'page';

  CardLocalDataSourceImpl(this._sqliteService);

  @override
  Future<CardModel?> fetchCardById(String game, String id) async {
    final result = await _sqliteService.query(
      cardsTable,
      where: '$columnGame = ? AND $columnId = ?',
      whereArgs: [game, id],
    );
    return result.isNotEmpty ? _parseCards(result).first : null;
  }

  @override
  Future<List<CardModel>> fetchCards(String game) async {
    final result = await _sqliteService.query(
      cardsTable,
      where: '$columnGame = ?',
      whereArgs: [game],
    );
    return _parseCards(result);
  }

  List<CardModel> _parseCards(List<Map<String, dynamic>> rows) {
    return rows.map((row) {
      return CardModel(
        cardId: row[columnId],
        game: row[columnGame],
        name: row[columnName],
        description: row[columnDescription],
        imageUrl: row[columnImageUrl],
        additionalData: json.decode(row[columnAdditionalData] ?? '{}'),
      );
    }).toList();
  }

  @override
  Future<int> fetchLastPage(String game) async {
    final result = await _sqliteService.query(
      pagesTable,
      where: '$columnGame = ?',
      whereArgs: [game],
    );
    return result.isNotEmpty ? (result.first[columnPage] ?? 0) : 0;
  }

  @override
  Future<bool> isPageExists(String game, int page) async {
    final result = await _sqliteService.query(
      pagesTable,
      where: '$columnGame = ? AND $columnPage = ?',
      whereArgs: [game, page],
    );
    return result.isNotEmpty;
  }

  @override
  Future<void> saveCards(String game, int page, List<CardModel> cards) async {
    final cardDataList = cards.map((card) => {
      columnId: card.cardId,
      columnGame: game,
      columnName: card.name,
      columnDescription: card.description,
      columnImageUrl: card.imageUrl,
      columnAdditionalData: json.encode(card.additionalData),
    }).toList();
    await _sqliteService.insertBatch(cardsTable, cardDataList);
    await _savePageIfNotExists(game, page);
  }

  Future<void> _savePageIfNotExists(String game, int page) async {
    if (!await isPageExists(game, page)) {
      await _sqliteService.insert(
        pagesTable,
        {columnGame: game, columnPage: page},
      );
    }
  }

  @override
  Future<void> clearCards(String game) async {
    final db = await _sqliteService.getDatabase();
    await db.transaction((txn) async {
      await txn.delete(cardsTable, where: '$columnGame = ?', whereArgs: [game]);
      await txn.delete(pagesTable, where: '$columnGame = ?', whereArgs: [game]);
    });
  }
}
