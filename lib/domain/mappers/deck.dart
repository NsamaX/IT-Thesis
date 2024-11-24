import '../../data/models/deck.dart';
import '../entities/deck.dart';
import 'card.dart';

class DeckMapper {
  static DeckEntity toEntity(DeckModel model) {
    return DeckEntity(
      deckId: model.deckId,
      deckName: model.deckName,
      cards: model.cards.map(CardMapper.toEntity).toList(),
    );
  }

  static DeckModel toModel(DeckEntity entity) {
    return DeckModel(
      deckId: entity.deckId,
      deckName: entity.deckName,
      cards: entity.cards.map(CardMapper.toModel).toList(),
    );
  }
}
