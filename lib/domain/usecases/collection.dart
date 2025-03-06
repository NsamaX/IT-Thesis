import 'package:nfc_project/data/repositories/collection.dart';

import '../entities/card.dart';
import '../mappers/card.dart';

class AddCardToCollectionUseCase {
  final CollectionRepository repository;

  AddCardToCollectionUseCase(this.repository);

  Future<void> call(CardEntity card) async {
    final cardModel = CardMapper.toModel(card);
    await repository.addCardToCollection(cardModel);
  }
}

class RemoveCardFromCollectionUseCase {
  final CollectionRepository repository;

  RemoveCardFromCollectionUseCase(this.repository);

  Future<void> call(String cardId) async {
    await repository.removeCardFromCollection(cardId);
  }
}

class FetchCollectionUseCase {
  final CollectionRepository repository;

  FetchCollectionUseCase(this.repository);

  Future<List<CardEntity>> call() async {
    final cardModels = await repository.fetchCollection();
    return cardModels.map(CardMapper.toEntity).toList();
  }
}
