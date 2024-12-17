import 'package:nfc_project/data/repositories/card.dart';
import '../entities/card.dart';
import '../mappers/card.dart';

class SyncCardsUseCase {
  final CardRepository cardRepository;

  SyncCardsUseCase(this.cardRepository);

  Future<List<CardEntity>> call(String game) async {
    final cardModels = await cardRepository.syncCards(game);
    return cardModels.map((model) => CardMapper.toEntity(model)).toList();
  }
}
