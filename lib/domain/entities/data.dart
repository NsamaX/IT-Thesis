enum Action {
  unknown,
  draw,
  returnToDeck,
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
}
