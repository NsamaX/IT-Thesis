import 'package:nfc_project/data/models/tag.dart';
import '../entities/tag.dart';

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
class TagMapper {
  static TagModel toModel(TagEntity entity) => TagModel(
    tagId: entity.tagId,
    cardId: entity.cardId,
    game: entity.game,
  );

  static TagEntity toEntity(TagModel model) => TagEntity(
    tagId: model.tagId,
    cardId: model.cardId,
    game: model.game,
  );
}
