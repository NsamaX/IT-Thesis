enum ActionModel {
  draw,
  returnToDeck,
  unknown,
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

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    tagId: json['tagId'] as String? ?? '',
    location: json['location'] as String? ?? '',
    action: ActionModel.values.firstWhere(
      (e) => e.name == json['action'],
      orElse: () => ActionModel.unknown,
    ),
    timestamp: json['timestamp'] != null
        ? DateTime.tryParse(json['timestamp']) ?? DateTime.now()
        : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'tagId': tagId,
    'location': location,
    'action': action.name,
    'timestamp': timestamp.toIso8601String(),
  };
}
