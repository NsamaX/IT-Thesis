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
      recordId: json['recordId'] as String? ?? '',
      createdAt: _parseDateTime(json['createdAt']),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => DataModel.fromJson(item as Map<String, dynamic>))
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

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
