import '../datasources/local/deck.dart';
import '../models/deck.dart';

abstract class DeckRepository {
  Future<void> saveDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
  Future<List<DeckModel>> loadDecks();
}

class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDataSource datasource;

  DeckRepositoryImpl(this.datasource);

  @override
  Future<void> saveDeck(DeckModel deck) => datasource.saveDeck(deck);

  @override
  Future<void> deleteDeck(String deckId) => datasource.deleteDeck(deckId);

  @override
  Future<List<DeckModel>> loadDecks() => datasource.loadDecks();
}
