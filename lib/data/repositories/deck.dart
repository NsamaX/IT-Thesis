// import '../datasources/remote/deck.dart';
// import '../../domain/entities/deck.dart';
// import '../../domain/mappers/deck.dart';

// class DeckRepository {
//   final DeckRemoteDataSource remoteDataSource;

//   DeckRepository({required this.remoteDataSource});

//   Future<Deck> fetchDeck(String deckId) async {
//     final deckModel = await remoteDataSource.fetchDeck(deckId);
//     return DeckMapper.toEntity(deckModel);
//   }

//   Future<void> saveDeck(Deck deck) async {
//     final deckModel = DeckMapper.toModel(deck);
//     await remoteDataSource.saveDeck(deckModel);
//   }

//   Future<void> deleteDeck(String deckId) async {
//     await remoteDataSource.deleteDeck(deckId);
//   }
// }
