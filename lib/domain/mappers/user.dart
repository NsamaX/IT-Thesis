import '../../data/models/user.dart';
import '../entities/user.dart';

class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      userId: model.userId,
      userName: model.userName,
      tagIds: model.tagIds,
      deckIds: model.deckIds,
      recordIds: model.recordIds,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      userName: entity.userName,
      tagIds: entity.tagIds,
      deckIds: entity.deckIds,
      recordIds: entity.recordIds,
    );
  }
}
