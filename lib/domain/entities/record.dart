import 'data.dart';

class RecordEntity {
  final String recordId;
  final String userId;
  final DateTime createdAt;
  final List<DataEntity> data;

  RecordEntity({
    required this.recordId,
    required this.userId,
    required this.createdAt,
    required this.data,
  });
}
