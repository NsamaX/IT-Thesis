import '../../data/models/record.dart';
import '../entities/record.dart';
import 'data.dart';

class RecordMapper {
  static RecordEntity toEntity(RecordModel model) {
    return RecordEntity(
      recordId: model.recordId,
      createdAt: model.createdAt,
      data: model.data
          .map((dataModel) => DataMapper.toEntity(dataModel))
          .toList(),
    );
  }

  static RecordModel toModel(RecordEntity entity) {
    return RecordModel(
      recordId: entity.recordId,
      createdAt: entity.createdAt,
      data: entity.data.map((data) => DataMapper.toModel(data)).toList(),
    );
  }
}
