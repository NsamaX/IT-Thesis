import '../datasources/local/deck.dart';
import '../models/deck.dart';

abstract class DeckRepository {
  Future<List<DeckModel>> getDecks();
  Future<void> saveDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
}

class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDataSource localDataSource;

  DeckRepositoryImpl(this.localDataSource);

  @override
  Future<List<DeckModel>> getDecks() async {
    return await localDataSource.getDecks();
  }

  @override
  Future<void> saveDeck(DeckModel deck) async {
    await localDataSource.saveDeck(deck);
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    await localDataSource.deleteDeck(deckId);
  }
}
