import 'data.dart';

class RecordEntity {
  final String recordId;
  final DateTime createdAt;
  final List<DataEntity> data;

  const RecordEntity({
    required this.recordId,
    required this.createdAt,
    required this.data,
  });

  RecordEntity copyWith({
    String? recordId,
    DateTime? createdAt,
    List<DataEntity>? data,
  }) => RecordEntity(
    recordId: recordId ?? this.recordId,
    createdAt: createdAt ?? this.createdAt,
    data: data ?? this.data,
  );
}
