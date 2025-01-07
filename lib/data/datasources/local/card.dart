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

  CardLocalDataSourceImpl(this._sqliteService);

  @override
  Future<CardModel?> fetchCardById(String game, String id) async {
    final result = await _sqliteService.query('cards', where: 'game = ? AND id = ?', whereArgs: [game, id]);
    return result.isNotEmpty ? _parseCards(result).first : null;
  }

  @override
  Future<List<CardModel>> fetchCards(String game) async {
    final result = await _sqliteService.query('cards', where: 'game = ?', whereArgs: [game]);
    return _parseCards(result);
  }

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
      } catch (_) {
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
  Future<int> fetchLastPage(String game) async {
    final result = await _sqliteService.query('pages', where: 'game = ?', whereArgs: [game]);
    return result.isNotEmpty ? (result.first['page'] ?? 0) : 0;
  }

  @override
  Future<bool> isPageExists(String game, int page) async {
    final result = await _sqliteService.query('pages', where: 'game = ? AND page = ?', whereArgs: [game, page]);
    return result.isNotEmpty;
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
    await _sqliteService.insertBatch('cards', cardDataList);
    await _savePageIfNotExists(game, page);
  }

  Future<void> _savePageIfNotExists(String game, int page) async {
    if (!await isPageExists(game, page)) {
      await _sqliteService.insert('pages', {'game': game, 'page': page});
    }
  }

  @override
  Future<void> clearCards(String game) async {
    await _sqliteService.getDatabase().then((db) {
      db.transaction((txn) async {
        await txn.delete('cards', where: 'game = ?', whereArgs: [game]);
        await txn.delete('pages', where: 'game = ?', whereArgs: [game]);
      });
    });
  }
}
