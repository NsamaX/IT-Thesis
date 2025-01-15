import 'package:nfc_project/data/models/user.dart';
import '../entities/user.dart';

class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      email: model.email,
      userId: model.userId,
      deckIds: model.deckIds,
      recordIds: model.recordIds,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      email: entity.email,
      userId: entity.userId,
      deckIds: entity.deckIds,
      recordIds: entity.recordIds,
    );
  }
}
