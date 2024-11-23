import '../../data/models/card.dart';
import '../entities/card.dart';

class CardMapper {
  static CardEntity toEntity(CardModel model) {
    return CardEntity(
      cardId: model.cardId,
      name: model.name,
      description: model.description,
      imageUrl: model.imageUrl,
      additionalData: model.additionalData,
    );
  }

  static CardModel toModel(CardEntity entity) {
    return CardModel(
      cardId: entity.cardId,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      additionalData: entity.additionalData,
    );
  }
}
