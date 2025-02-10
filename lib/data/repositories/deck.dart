import '../datasources/local/deck.dart';
import '../models/deck.dart';

abstract class DeckRepository {
  Future<void> saveDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
  Future<List<DeckModel>> loadDecks();
}

class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDataSource deckLocalDataSource;

  DeckRepositoryImpl(this.deckLocalDataSource);

  @override
  Future<void> saveDeck(DeckModel deck) async => await deckLocalDataSource.saveDeck(deck);

  @override
  Future<void> deleteDeck(String deckId) async => await deckLocalDataSource.deleteDeck(deckId);

  @override
  Future<List<DeckModel>> loadDecks() async => await deckLocalDataSource.loadDecks();
}
