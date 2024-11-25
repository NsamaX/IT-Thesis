import 'package:flutter/foundation.dart';

enum ActionModel {
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
      tagId: json['tagId'],
      location: json['location'],
      action: ActionModel.values.firstWhere(
        (e) => describeEnum(e) == json['action'],
        orElse: () => ActionModel.draw,
      ),
      timestamp: DateTime.parse(json['timestamp']),
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
