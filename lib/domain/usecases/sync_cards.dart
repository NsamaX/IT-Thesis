import 'package:nfc_project/data/repositories/card.dart';
import '../entities/card.dart';
import '../mappers/card.dart';

class SyncCardsUseCase {
  final CardRepository repository;

  SyncCardsUseCase(this.repository);

  Future<List<CardEntity>> call(String game) async {
    final cardModels = await repository.syncCards(game);
    return cardModels.map((model) => CardMapper.toEntity(model)).toList();
  }
}
