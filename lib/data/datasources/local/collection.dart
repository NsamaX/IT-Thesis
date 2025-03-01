import 'dart:convert';

import 'package:nfc_project/core/storage/sqlite.dart';

import '../../models/card.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
abstract class CollectionLocalDataSource {
  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> addCardToCollection(CardModel card);

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> removeCardFromCollection(String cardId);

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
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
