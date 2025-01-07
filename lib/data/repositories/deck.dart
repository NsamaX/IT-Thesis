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
  Future<void> saveDeck(DeckModel deck) async {
    try {
      await localDataSource.saveDeck(deck);
    } catch (e) {
      throw Exception('Failed to save deck: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    try {
      await localDataSource.deleteDeck(deckId);
    } catch (e) {
      throw Exception('Failed to delete deck with ID $deckId: ${e.toString()}');
    }
  }

  @override
  Future<List<DeckModel>> loadDecks() async {
    try {
      return await localDataSource.loadDecks();
    } catch (e) {
      throw Exception('Failed to load decks: ${e.toString()}');
    }
  }
}
