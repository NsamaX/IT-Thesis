import 'package:flutter/foundation.dart';

enum ActionModel {
  draw,
  returnToDeck,
}

class DataModel {
  final String tagId;
  final String location;
  final DateTime timestamp;
  final ActionModel action;

  DataModel({
    required this.tagId,
    required this.location,
    required this.timestamp,
    required this.action,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      tagId: json['tagId'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
      action: ActionModel.values.firstWhere(
        (e) => describeEnum(e) == json['action'],
        orElse: () => ActionModel.draw,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'action': describeEnum(action),
    };
  }
}
