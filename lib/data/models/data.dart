import 'package:flutter/foundation.dart';

enum ActionModel {
  unknown,
  draw,
  returnToDeck,
}

class DataModel {
  final String tagId;
  final String location;
  final ActionModel action;
  final DateTime timestamp;

  DataModel({
    required this.tagId,
    required this.location,
    required this.action,
    required this.timestamp,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      tagId: json['tagId'] ?? '',
      location: json['location'] ?? '',
      action: ActionModel.values.firstWhere(
        (e) => describeEnum(e) == json['action'],
        orElse: () => ActionModel.unknown,
      ),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'location': location,
      'action': describeEnum(action),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
