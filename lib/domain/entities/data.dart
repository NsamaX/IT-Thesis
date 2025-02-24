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
enum Action {
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
class DataEntity {
  final String tagId;
  final String name;
  final String imageUrl;
  final String location;
  final Action action;
  final DateTime timestamp;

  const DataEntity({
    required this.tagId,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.action,
    required this.timestamp,
  });

  DataEntity copyWith({
    String? tagId,
    String? name,
    String? imageUrl,
    String? location,
    Action? action,
    DateTime? timestamp,
  }) => DataEntity(
    tagId: tagId ?? this.tagId,
    name: name ?? this.name,
    imageUrl: imageUrl ?? this.imageUrl,
    location: location ?? this.location,
    action: action ?? this.action,
    timestamp: timestamp ?? this.timestamp,
  );
}
