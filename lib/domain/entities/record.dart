import 'data.dart';

class RecordEntity {
  final String recordId;
  final DateTime createdAt;
  final List<DataEntity> data;

  RecordEntity({
    required this.recordId,
    required this.createdAt,
    required this.data,
  });

  RecordEntity addAction(DataEntity newAction) {
    return RecordEntity(
      recordId: recordId,
      createdAt: createdAt,
      data: [...data, newAction],
    );
  }
}
