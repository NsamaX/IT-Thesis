import 'package:nfc_project/data/models/data.dart';
import '../entities/data.dart';

class DataMapper {
  static DataEntity toEntity(DataModel model) {
    return DataEntity(
      tagId: model.tagId,
      location: model.location,
      action: Action.values[model.action.index],
      timestamp: model.timestamp,
    );
  }

  static DataModel toModel(DataEntity entity) {
    return DataModel(
      tagId: entity.tagId,
      location: entity.location,
      action: ActionModel.values[entity.action.index],
      timestamp: entity.timestamp,
    );
  }

  static List<DataEntity> toEntityList(List<DataModel> models) {
    return models.map(toEntity).toList();
  }

  static List<DataModel> toModelList(List<DataEntity> entities) {
    return entities.map(toModel).toList();
  }
}
