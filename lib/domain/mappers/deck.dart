import '../../data/models/deck.dart';
import '../entities/deck.dart';
import 'card.dart';

class DeckMapper {
  static DeckEntity toEntity(DeckModel model) {
    return DeckEntity(
      deckId: model.deckId,
      deckName: model.deckName,
      cards: model.cards.map(
        (key, value) => MapEntry(
          CardMapper.toEntity(key),
          value,
        ),
      ),
    );
  }

  static DeckModel toModel(DeckEntity entity) {
    return DeckModel(
      deckId: entity.deckId,
      deckName: entity.deckName,
      cards: entity.cards.map(
        (key, value) => MapEntry(
          CardMapper.toModel(key),
          value,
        ),
      ),
    );
  }
}
