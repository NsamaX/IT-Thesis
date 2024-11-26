import '../../data/models/deck.dart';
import '../../data/repositories/deck.dart';
import '../entities/card.dart';
import '../entities/deck.dart';
import '../mappers/card.dart';

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

class SaveDeckUseCase {
  final DeckRepository repository;

  SaveDeckUseCase(this.repository);

  Future<void> call(DeckEntity deck) async {
    final deckModel = DeckModel(
      deckId: deck.deckId,
      deckName: deck.deckName,
      cards: deck.cards
          .map((key, value) => MapEntry(CardMapper.toModel(key), value)),
    );
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

class LoadDecksUseCase {
  final DeckRepository repository;

  LoadDecksUseCase(this.repository);

  Future<List<DeckEntity>> call() async {
    final decksData = await repository.getDecks();
    final decks = decksData.entries.map((entry) {
      final deckModel = DeckModel.fromJson(entry.value);
      return DeckEntity(
        deckId: deckModel.deckId,
        deckName: deckModel.deckName,
        cards: deckModel.cards.map(
          (key, value) => MapEntry(CardMapper.toEntity(key), value),
        ),
      );
    }).toList();
    return decks;
  }
}
