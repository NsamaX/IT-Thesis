import 'package:nfc_project/data/models/card.dart';

import '../entities/card.dart';

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
class CardMapper {
  static CardModel toModel(CardEntity entity) => CardModel(
    cardId: entity.cardId,
    game: entity.game,
    name: entity.name,
    description: entity.description,
    imageUrl: entity.imageUrl,
    additionalData: entity.additionalData,
  );

  static CardEntity toEntity(CardModel model) => CardEntity(
    cardId: model.cardId,
    game: model.game,
    name: model.name,
    description: model.description,
    imageUrl: model.imageUrl,
    additionalData: model.additionalData,
  );
}
