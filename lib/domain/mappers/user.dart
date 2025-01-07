import 'package:nfc_project/data/models/user.dart';
import '../entities/user.dart';

class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      email: model.email,
      userId: model.userId,
      tagIds: model.tagIds,
      deckIds: model.deckIds,
      recordIds: model.recordIds,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      email: entity.email,
      userId: entity.userId,
      tagIds: entity.tagIds,
      deckIds: entity.deckIds,
      recordIds: entity.recordIds,
    );
  }

  static List<UserEntity> toEntityList(List<UserModel> models) {
    return models.map(toEntity).toList();
  }

  static List<UserModel> toModelList(List<UserEntity> entities) {
    return entities.map(toModel).toList();
  }
}
