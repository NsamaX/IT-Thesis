import '../../data/models/tag.dart';
import '../entities/tag.dart';

class TagMapper {
  static TagEntity toEntity(TagModel model) {
    return TagEntity(
      tagId: model.tagId,
      game: model.game,
      cardId: model.cardId,
      timestamp: model.timestamp,
    );
  }

  static TagModel toModel(TagEntity entity) {
    return TagModel(
      tagId: entity.tagId,
      game: entity.game,
      cardId: entity.cardId,
      timestamp: entity.timestamp,
    );
  }
}
