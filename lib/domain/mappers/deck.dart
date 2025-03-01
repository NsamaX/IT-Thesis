import 'package:nfc_project/data/models/deck.dart';

import '../entities/deck.dart';
import 'card.dart';

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
class DeckMapper {
  static DeckModel toModel(DeckEntity entity) => DeckModel(
    deckId: entity.deckId,
    deckName: entity.deckName,
    cards: entity.cards.map(
      (card, count) => MapEntry(CardMapper.toModel(card), count),
    ),
  );

  static DeckEntity toEntity(DeckModel model) => DeckEntity(
    deckId: model.deckId,
    deckName: model.deckName,
    cards: model.cards.map(
      (card, count) => MapEntry(CardMapper.toEntity(card), count),
    ),
  );
}
