import 'package:nfc_project/data/repositories/deck.dart';
import '../entities/card.dart';
import '../entities/deck.dart';
import '../mappers/deck.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class AddCardUseCase {
  DeckEntity call(DeckEntity deck, CardEntity card, int count) {
    final updatedCards = Map<CardEntity, int>.from(deck.cards);
    updatedCards[card] = (updatedCards[card] ?? 0) + count;
    return deck.copyWith(cards: updatedCards);
  }
}

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class RemoveCardUseCase {
  DeckEntity call(DeckEntity deck, CardEntity card) {
    final updatedCards = Map<CardEntity, int>.from(deck.cards);
    if (updatedCards.containsKey(card)) {
      updatedCards.update(card, (count) => count - 1, ifAbsent: () => 0);
      if (updatedCards[card]! <= 0) {
        updatedCards.remove(card);
      }
    }
    return deck.copyWith(cards: updatedCards);
  }
}

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class SaveDeckUseCase {
  final DeckRepository repository;

  SaveDeckUseCase(this.repository);

  Future<void> call(DeckEntity deck) async => repository.saveDeck(DeckMapper.toModel(deck));
}

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class DeleteDeckUseCase {
  final DeckRepository repository;

  DeleteDeckUseCase(this.repository);

  Future<void> call(String deckId) async => repository.deleteDeck(deckId);
}

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class LoadDecksUseCase {
  final DeckRepository repository;

  LoadDecksUseCase(this.repository);

  Future<List<DeckEntity>> call() async {
    final decksModel = await repository.loadDecks();
    return decksModel.map(DeckMapper.toEntity).toList();
  }
}
