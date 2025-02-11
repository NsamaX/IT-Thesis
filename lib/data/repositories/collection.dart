import '../datasources/local/collection.dart';
import '../models/card.dart';

abstract class CollectionRepository {
  Future<void> addCardToCollection(CardModel card);
  Future<void> removeCardFromCollection(String cardId);
  Future<List<CardModel>> fetchCollection();
}

class CollectionRepositoryImpl implements CollectionRepository {
  final CollectionLocalDataSource collectionLocalDataSource;

  CollectionRepositoryImpl(this.collectionLocalDataSource);

  @override
  Future<void> addCardToCollection(CardModel card) async {
    await collectionLocalDataSource.addCardToCollection(card);
  }

  @override
  Future<void> removeCardFromCollection(String cardId) async {
    await collectionLocalDataSource.removeCardFromCollection(cardId);
  }

  @override
  Future<List<CardModel>> fetchCollection() async {
    return await collectionLocalDataSource.fetchCollection();
  }
}
