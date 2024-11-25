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

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      recordId: json['recordId'],
      createdAt: DateTime.parse(json['createdAt']),
      data: (json['data'] as List<dynamic>)
          .map((item) => DataModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'createdAt': createdAt.toIso8601String(),
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
