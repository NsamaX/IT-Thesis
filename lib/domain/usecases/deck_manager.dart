import '../entities/card.dart';
import '../entities/deck.dart';

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
