import '../datasources/local/deck.dart';
import '../models/deck.dart';

abstract class DeckRepository {
  Future<Map<String, dynamic>> getDecks();
  Future<void> saveDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
}

class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDataSource localDataSource;

  DeckRepositoryImpl({required this.localDataSource});

  @override
  Future<Map<String, dynamic>> getDecks() async {
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
