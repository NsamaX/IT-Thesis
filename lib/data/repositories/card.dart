import '../datasources/remote/game_factory.dart';
import '../models/card.dart';

abstract class CardRepository {
  Future<List<CardModel>> fetchAllCards();
  Future<List<CardModel>> fetchCardsPage(int page);
  Future<CardModel> fetchCardById(String cardId);
}

class CardRepositoryImpl implements CardRepository {
  final GameApi gameApi;

  CardRepositoryImpl(this.gameApi);

  @override
  Future<List<CardModel>> fetchAllCards() async {
    return await gameApi.fetchAllCards();
  }

  @override
  Future<List<CardModel>> fetchCardsPage(int page) async {
    return await gameApi.fetchCardsPage(page);
  }

  @override
  Future<CardModel> fetchCardById(String cardId) async {
    return await gameApi.fetchCardById(cardId);
  }
}
