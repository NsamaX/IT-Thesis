import 'package:nfc_project/data/repositories/card.dart';
import '../entities/card.dart';
import '../mappers/card.dart';

class FetchCardByIdUseCase {
  final CardRepository cardRepository;

  FetchCardByIdUseCase(this.cardRepository);

  Future<CardEntity> call(String game, String id) async {
    final localCard = await cardRepository.fetchCardById(game, id);
    return CardMapper.toEntity(localCard);
  }
}

class SyncCardsUseCase {
  final CardRepository cardRepository;

  SyncCardsUseCase(this.cardRepository);

  Future<List<CardEntity>> call(String game) async {
    final cardModels = await cardRepository.syncCards(game);
    return cardModels.map(CardMapper.toEntity).toList();
  }
}
