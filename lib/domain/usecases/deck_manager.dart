import 'package:nfc_project/data/repositories/deck.dart';
import '../entities/card.dart';
import '../entities/deck.dart';
import '../mappers/deck.dart';

class AddCardUseCase {
  DeckEntity call(DeckEntity deck, CardEntity card, int count) {
    final updatedCards = Map<CardEntity, int>.from(deck.cards);
    updatedCards[card] = (updatedCards[card] ?? 0) + count;
    return deck.copyWith(cards: updatedCards);
  }
}

class RemoveCardUseCase {
  DeckEntity call(DeckEntity deck, CardEntity card) {
    final updatedCards = Map<CardEntity, int>.from(deck.cards);
    if (updatedCards.containsKey(card)) {
      updatedCards[card] = updatedCards[card]! - 1;
      if (updatedCards[card]! <= 0) {
        updatedCards.remove(card);
      }
    }
    return deck.copyWith(cards: updatedCards);
  }
}

class SaveDeckUseCase {
  final DeckRepository deckRepository;

  SaveDeckUseCase(this.deckRepository);

  Future<void> call(DeckEntity deck) async => deckRepository.saveDeck(DeckMapper.toModel(deck));
}

class DeleteDeckUseCase {
  final DeckRepository deckRepository;

  DeleteDeckUseCase(this.deckRepository);

  Future<void> call(String deckId) async => deckRepository.deleteDeck(deckId);
}

class LoadDecksUseCase {
  final DeckRepository deckRepository;

  LoadDecksUseCase(this.deckRepository);

  Future<List<DeckEntity>> call() async {
    final decksModel = await deckRepository.loadDecks();
    return decksModel.map(DeckMapper.toEntity).toList();
  }
}
