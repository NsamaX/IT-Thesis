import 'package:nfc_project/data/repositories/deck.dart';
import '../entities/card.dart';
import '../entities/deck.dart';
import '../mappers/deck.dart';

class AddCardUseCase {
  DeckEntity call(DeckEntity deck, CardEntity card) {
    final updatedCards = Map<CardEntity, int>.from(deck.cards);
    if (updatedCards.containsKey(card)) {
      updatedCards[card] = updatedCards[card]! + 1;
    } else {
      updatedCards[card] = 1;
    }
    return deck.copyWith(cards: updatedCards);
  }
}

class RemoveCardUseCase {
  DeckEntity call(DeckEntity deck, CardEntity card) {
    final updatedCards = Map<CardEntity, int>.from(deck.cards);
    if (updatedCards.containsKey(card)) {
      if (updatedCards[card]! > 1) {
        updatedCards[card] = updatedCards[card]! - 1;
      } else {
        updatedCards.remove(card);
      }
    }
    return deck.copyWith(cards: updatedCards);
  }
}

class LoadDecksUseCase {
  final DeckRepository repository;

  LoadDecksUseCase(this.repository);

  Future<List<DeckEntity>> call() async {
    final decksModel = await repository.loadDecks();
    return decksModel.map((deckModel) => DeckMapper.toEntity(deckModel)).toList();
  }
}

class SaveDeckUseCase {
  final DeckRepository repository;

  SaveDeckUseCase(this.repository);

  Future<void> call(DeckEntity deck) async {
    final deckModel = DeckMapper.toModel(deck);
    await repository.saveDeck(deckModel);
  }
}

class DeleteDeckUseCase {
  final DeckRepository repository;

  DeleteDeckUseCase(this.repository);

  Future<void> call(String deckId) async {
    await repository.deleteDeck(deckId);
  }
}
