import 'package:nfc_project/data/models/record.dart';
import '../entities/record.dart';
import 'data.dart';

class RecordMapper {
  static RecordEntity toEntity(RecordModel model) {
    return RecordEntity(
      recordId: model.recordId,
      createdAt: model.createdAt,
      data: model.data.map(DataMapper.toEntity).toList(),
    );
  }

  static RecordModel toModel(RecordEntity entity) {
    return RecordModel(
      recordId: entity.recordId,
      createdAt: entity.createdAt,
      data: entity.data.map(DataMapper.toModel).toList(),
    );
  }

  static List<RecordEntity> toEntityList(List<RecordModel> models) {
    return models.map(toEntity).toList();
  }

  static List<RecordModel> toModelList(List<RecordEntity> entities) {
    return entities.map(toModel).toList();
  }
}
