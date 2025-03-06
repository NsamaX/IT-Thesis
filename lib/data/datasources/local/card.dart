import 'dart:collection';
import 'dart:convert';

import 'package:nfc_project/core/storage/sqlite.dart';

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
