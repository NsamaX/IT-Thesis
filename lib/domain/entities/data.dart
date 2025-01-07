enum Action {
  draw,
  returnToDeck,
  unknown,
}

class DataEntity {
  final String tagId;
  final String location;
  final Action action;
  final DateTime timestamp;

  DataEntity({
    required this.tagId,
    required this.location,
    required this.action,
    required this.timestamp,
  });

  DataEntity copyWith({
    String? tagId,
    String? location,
    Action? action,
    DateTime? timestamp,
  }) {
    return DataEntity(
      tagId: tagId ?? this.tagId,
      location: location ?? this.location,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
