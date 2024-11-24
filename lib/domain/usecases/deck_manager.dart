import '../entities/card.dart';
import '../entities/deck.dart';

class AddCardUseCase {
  DeckEntity call(DeckEntity deck, CardEntity card) {
    final updatedCards = [...deck.cards, card];
    return deck.copyWith(cards: updatedCards);
  }
}

class RemoveCardUseCase {
  DeckEntity call(DeckEntity deck, CardEntity card) {
    final updatedCards = deck.cards.where((c) => c != card).toList();
    return deck.copyWith(cards: updatedCards);
  }
}
