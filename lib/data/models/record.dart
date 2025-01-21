import 'data.dart';

class RecordModel {
  final String recordId;
  final DateTime createdAt;
  final List<DataModel> data;

  RecordModel({
    required this.recordId,
    required this.createdAt,
    required this.data,
  });

  factory RecordModel.fromJson(Map<String, dynamic> json) => RecordModel(
    recordId: json['recordId'] as String? ?? '',
    createdAt: DateTime.parse(json['createdAt'] as String? ?? ''),
    data: (json['data'] as List<dynamic>? ?? [])
        .map((item) => DataModel.fromJson(item as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'recordId': recordId,
    'createdAt': createdAt.toIso8601String(),
    'data': data.map((item) => item.toJson()).toList(),
  };
}
