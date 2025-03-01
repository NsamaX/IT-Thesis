import 'package:nfc_project/data/repositories/card.dart';

import '../entities/card.dart';
import '../mappers/card.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class FetchCardByIdUseCase {
  final CardRepository repository;

  FetchCardByIdUseCase(this.repository);

  Future<CardEntity> call(String game, String id) async {
    final localCard = await repository.fetchCardById(game, id);
    return CardMapper.toEntity(localCard);
  }
}

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class SyncCardsUseCase {
  final CardRepository repository;

  SyncCardsUseCase(this.repository);

  Future<List<CardEntity>> call(String game) async {
    final cardModels = await repository.syncCards(game);
    return cardModels.map(CardMapper.toEntity).toList();
  }
}
