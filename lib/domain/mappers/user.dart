import '../../data/models/user.dart';
import '../entities/user.dart';

class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      userId: model.userId,
      email: model.email,
      tagIds: model.tagIds,
      deckIds: model.deckIds,
      recordIds: model.recordIds,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      email: entity.email,
      tagIds: entity.tagIds,
      deckIds: entity.deckIds,
      recordIds: entity.recordIds,
    );
  }
}
