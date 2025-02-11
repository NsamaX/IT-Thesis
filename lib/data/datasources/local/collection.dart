import 'dart:convert';
import 'package:nfc_project/core/services/sqlite.dart';
import '../../models/card.dart';

abstract class CollectionLocalDataSource {
  Future<void> addCardToCollection(CardModel card);
  Future<void> removeCardFromCollection(String cardId);
  Future<List<CardModel>> fetchCollection();
}

class CollectionLocalDataSourceImpl implements CollectionLocalDataSource {
  final SQLiteService _sqliteService;

  static const String collectionTable = 'collections';
  static const String columnCollectId = 'collectId';
  static const String columnCard = 'card';

  CollectionLocalDataSourceImpl(this._sqliteService);

  @override
  Future<void> addCardToCollection(CardModel card) async {
    final cardData = json.encode({
      'cardId': card.cardId,
      'game': card.game,
      'name': card.name,
      'imageUrl': card.imageUrl,
      'description': card.description,
    });
    await _sqliteService.insert(
      collectionTable,
      {
        columnCollectId: card.cardId,
        columnCard: cardData,
      },
    );
  }

  @override
  Future<void> removeCardFromCollection(String cardId) async {
    await _sqliteService.delete(
      collectionTable,
      columnCollectId,
      cardId,
    );
  }

  @override
  Future<List<CardModel>> fetchCollection() async {
    final result = await _sqliteService.query(collectionTable);
    return result.map((row) {
      final Map<String, dynamic> cardData = json.decode(row[columnCard]);
      return CardModel.fromJson(cardData);
    }).toList();
  }
}
