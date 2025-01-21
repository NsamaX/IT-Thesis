import '../datasources/local/deck.dart';
import '../models/deck.dart';

abstract class DeckRepository {
  Future<void> saveDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
  Future<List<DeckModel>> loadDecks();
}

class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDataSource localDataSource;

  DeckRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveDeck(DeckModel deck) async => await localDataSource.saveDeck(deck);

  @override
  Future<void> deleteDeck(String deckId) async => await localDataSource.deleteDeck(deckId);

  @override
  Future<List<DeckModel>> loadDecks() async => await localDataSource.loadDecks();
}
