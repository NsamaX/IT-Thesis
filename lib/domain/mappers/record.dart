import 'package:nfc_project/data/models/record.dart';
import '../entities/record.dart';
import 'data.dart';

class RecordMapper {
  static RecordModel toModel(RecordEntity entity) => RecordModel(
    recordId: entity.recordId,
    createdAt: entity.createdAt,
    data: entity.data.map(DataMapper.toModel).toList(),
  );

  static RecordEntity toEntity(RecordModel model) => RecordEntity(
    recordId: model.recordId,
    createdAt: model.createdAt,
    data: model.data.map(DataMapper.toEntity).toList(),
  );
}
