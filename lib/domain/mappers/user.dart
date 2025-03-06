import 'package:nfc_project/data/models/user.dart';

import '../entities/user.dart';

class UserMapper {
  static UserModel toModel(UserEntity entity) => UserModel(
    email: entity.email,
    userId: entity.userId,
    deckIds: entity.deckIds,
    recordIds: entity.recordIds,
  );

  static UserEntity toEntity(UserModel model) => UserEntity(
    email: model.email,
    userId: model.userId,
    deckIds: model.deckIds,
    recordIds: model.recordIds,
  );
}
