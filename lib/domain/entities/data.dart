enum Action {
  draw,
  returnToDeck,
}

class DataEntity {
  final String tagId;
  final String location;
  final DateTime timestamp;
  final Action action;

  DataEntity({
    required this.tagId,
    required this.location,
    required this.timestamp,
    required this.action,
  });
}
