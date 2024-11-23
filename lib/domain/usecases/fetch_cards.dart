import '../../data/repositories/card.dart';
import '../../domain/entities/card.dart';

class FetchCardUseCase {
  final String game;

  FetchCardUseCase(this.game);

  Future<CardEntity> call(String cardId) async {
    return await CardRepository(game).fetchCard(cardId);
  }
}

class FetchCardsPageUseCase {
  final String game;

  FetchCardsPageUseCase(this.game);

  Future<List<CardEntity>> call(int page) async {
    return await CardRepository(game).fetchCardsPage(page);
  }
}

class FetchAllCardsUseCase {
  final String game;

  FetchAllCardsUseCase(this.game);

  Future<List<CardEntity>> call() async {
    return await CardRepository(game).fetchAllCards();
  }
}
