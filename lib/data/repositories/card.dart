import '../datasources/remote/game_api_factory.dart';
import '../models/card.dart';
import '../../domain/entities/card.dart';
import '../../domain/mappers/card.dart';

abstract class CardRepository {
  Future<CardEntity> fetchCard(String cardId);
  Future<List<CardEntity>> fetchCardsPage(int page);
  Future<List<CardEntity>> fetchAllCards();
}

class CardRepositoryImpl {
  final GameApi gameApi;

  CardRepositoryImpl(String game) : gameApi = GameApiFactory.createApi(game);

  Future<CardEntity> fetchCard(String cardId) async {
    final cardData = await gameApi.fetchCard(cardId);
    final cardModel = CardModel.fromJson(cardData);
    return CardMapper.toEntity(cardModel);
  }

  Future<List<CardEntity>> fetchCardsPage(int page) async {
    final cardsData = await gameApi.fetchCardsPage(page);
    return cardsData.map((cardData) {
      final cardModel = CardModel.fromJson(cardData);
      return CardMapper.toEntity(cardModel);
    }).toList();
  }

  Future<List<CardEntity>> fetchAllCards() async {
    final cardsData = await gameApi.fetchAllCards();
    return cardsData.map((cardData) {
      final cardModel = CardModel.fromJson(cardData);
      return CardMapper.toEntity(cardModel);
    }).toList();
  }
}
