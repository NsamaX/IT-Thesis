import '../../data/models/tag.dart';
import '../entities/tag.dart';

class TagMapper {
  static TagEntity toEntity(TagModel model) {
    return TagEntity(
      tagId: model.tagId,
      cardId: model.cardId,
      game: model.game,
      timestamp: model.timestamp,
    );
  }

  static TagModel toModel(TagEntity entity) {
    return TagModel(
      tagId: entity.tagId,
      cardId: entity.cardId,
      game: entity.game,
      timestamp: entity.timestamp,
    );
  }
}
