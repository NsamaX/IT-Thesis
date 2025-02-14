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
  Future<void> saveDeck(DeckModel deck) async => await datasource.saveDeck(deck);

  @override
  Future<void> deleteDeck(String deckId) async => await datasource.deleteDeck(deckId);

  @override
  Future<List<DeckModel>> loadDecks() async => await datasource.loadDecks();
}
