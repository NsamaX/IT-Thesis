import '../datasources/remote/game_api_factory.dart';
import '../models/card.dart';

abstract class CardRepository {
  Future<CardModel> fetchCard(String cardId);
  Future<List<CardModel>> fetchCardsPage(int page);
  Future<List<CardModel>> fetchAllCards();
}

class CardRepositoryImpl implements CardRepository {
  final GameApi gameApi;

  CardRepositoryImpl(this.gameApi);

  @override
  Future<CardModel> fetchCard(String cardId) async {
    return await gameApi.fetchCard(cardId);
  }

  @override
  Future<List<CardModel>> fetchCardsPage(int page) async {
    return await gameApi.fetchCardsPage(page);
  }

  @override
  Future<List<CardModel>> fetchAllCards() async {
    return await gameApi.fetchAllCards();
  }
}
