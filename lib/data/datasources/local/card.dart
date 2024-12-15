import 'dart:convert';
import 'package:nfc_project/core/services/sqlite.dart';
import '../../models/card.dart';

abstract class CardLocalDataSource {
  Future<List<CardModel>> fetchCards(String game);
  Future<int> fetchLastPage(String game);
  Future<void> saveCards(String game, int page, List<CardModel> cards);
  Future<void> clearCards(String game);
}

class CardLocalDataSourceImpl implements CardLocalDataSource {
  final SQLiteService _sqliteService;

  CardLocalDataSourceImpl(this._sqliteService);

  @override
  Future<List<CardModel>> fetchCards(String game) async {
    final result = await _sqliteService.query('cards');
    return result
        .where((row) => row['game'] == game)
        .map((row) => CardModel(
              cardId: row['id'],
              game: row['game'],
              name: row['name'],
              description: row['description'],
              imageUrl: row['imageUrl'],
              additionalData: json.decode(row['additionalData']),
            ))
        .toList();
  }

  @override
  Future<int> fetchLastPage(String game) async {
    final result = await _sqliteService.query('pages');
    final pageData = result.firstWhere(
      (row) => row['game'] == game,
      orElse: () => {'page': 0},
    );
    return pageData['page'] ?? 0;
  }

  @override
  Future<void> saveCards(String game, int page, List<CardModel> cards) async {
    for (var card in cards) {
      await _sqliteService.insert('cards', {
        'id': card.cardId,
        'game': game,
        'name': card.name,
        'description': card.description,
        'imageUrl': card.imageUrl,
        'additionalData': json.encode(card.additionalData),
      });
    }
    await _sqliteService.insert('pages', {
      'game': game,
      'page': page,
    });
  }

  @override
  Future<void> clearCards(String game) async {
    await _sqliteService.delete('cards', 'game', game);
    await _sqliteService.delete('pages', 'game', game);
  }
}
