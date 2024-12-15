import 'package:nfc_project/data/repositories/card.dart';
import '../entities/card.dart';
import '../mappers/card.dart';

class FetchAllCardsUseCase {
  final CardRepository cardRepository;

  FetchAllCardsUseCase(this.cardRepository);

  Future<List<CardEntity>> call() async {
    final cardModels = await cardRepository.fetchAllCards();
    return cardModels.map((model) => CardMapper.toEntity(model)).toList();
  }
}

class FetchCardsPageUseCase {
  final CardRepository cardRepository;

  FetchCardsPageUseCase(this.cardRepository);

  Future<List<CardEntity>> call(int page) async {
    final cardModels = await cardRepository.fetchCardsPage(page);
    return cardModels.map((model) => CardMapper.toEntity(model)).toList();
  }
}

