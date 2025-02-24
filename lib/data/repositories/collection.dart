import '../datasources/local/collection.dart';
import '../models/card.dart';

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
abstract class CollectionRepository {
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
