import 'package:nfc_project/data/repositories/collection.dart';
import '../entities/card.dart';
import '../mappers/card.dart';

class AddCardToCollectionUseCase {
  final CollectionRepository collectionRepository;

  AddCardToCollectionUseCase(this.collectionRepository);

  Future<void> call(CardEntity card) async {
    final cardModel = CardMapper.toModel(card);
    await collectionRepository.addCardToCollection(cardModel);
  }
}

class RemoveCardFromCollectionUseCase {
  final CollectionRepository collectionRepository;

  RemoveCardFromCollectionUseCase(this.collectionRepository);

  Future<void> call(String cardId) async {
    await collectionRepository.removeCardFromCollection(cardId);
  }
}

class FetchCollectionUseCase {
  final CollectionRepository collectionRepository;

  FetchCollectionUseCase(this.collectionRepository);

  Future<List<CardEntity>> call() async {
    final cardModels = await collectionRepository.fetchCollection();
    return cardModels.map(CardMapper.toEntity).toList();
  }
}
