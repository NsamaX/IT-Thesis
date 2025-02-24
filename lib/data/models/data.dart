/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
enum ActionModel {
  draw,
  returnToDeck,
  unknown,
}

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class DataModel {
  final String tagId;
  final String name;
  final String imageUrl;
  final String location;
  final ActionModel action;
  final DateTime timestamp;

  const DataModel({
    required this.tagId,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.action,
    required this.timestamp,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    tagId: json['tagId'] as String? ?? '',
    name: json['name'] as String? ?? '',
    imageUrl: json['imageUrl'] as String? ?? '',
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
    'name': name,
    'imageUrl': imageUrl,
    'location': location,
    'action': action.name,
    'timestamp': timestamp.toIso8601String(),
  };
}
