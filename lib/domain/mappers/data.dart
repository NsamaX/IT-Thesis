import 'package:nfc_project/data/models/data.dart';
import '../entities/data.dart';

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
class DataMapper {
  static DataModel toModel(DataEntity entity) => DataModel(
    tagId: entity.tagId,
    name: entity.name,
    imageUrl: entity.imageUrl,
    location: entity.location,
    action: ActionModel.values[entity.action.index],
    timestamp: entity.timestamp,
  );

  static DataEntity toEntity(DataModel model) => DataEntity(
    tagId: model.tagId,
    name: model.name,
    imageUrl: model.imageUrl,
    location: model.location,
    action: Action.values[model.action.index],
    timestamp: model.timestamp,
  );
}
