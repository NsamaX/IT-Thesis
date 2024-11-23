import '../../data/models/deck.dart';
import '../entities/deck.dart';

class DeckMapper {
  static DeckEntity toEntity(DeckModel model) {
    return DeckEntity(
      deckId: model.deckId,
      deckName: model.deckName,
      tagIds: model.tagIds,
    );
  }

  static DeckModel toModel(DeckEntity entity) {
    return DeckModel(
      deckId: entity.deckId,
      deckName: entity.deckName,
      tagIds: entity.tagIds,
    );
  }
}
