enum Action {
  draw,
  returnToDeck,
  unknown,
}

class DataEntity {
  final String tagId;
  final String name;
  final String location;
  final Action action;
  final DateTime timestamp;

  DataEntity({
    required this.tagId,
    required this.name,
    required this.location,
    required this.action,
    required this.timestamp,
  });

  DataEntity copyWith({
    String? tagId,
    String? name,
    String? location,
    Action? action,
    DateTime? timestamp,
  }) => DataEntity(
    tagId: tagId ?? this.tagId,
    name: name ?? this.name,
    location: location ?? this.location,
    action: action ?? this.action,
    timestamp: timestamp ?? this.timestamp,
  );
}
