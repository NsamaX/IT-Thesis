class TagEntity {
  final String tagId;
  final String game;
  final String cardId;
  final DateTime timestamp;

  TagEntity({
    required this.tagId,
    required this.game,
    required this.cardId,
    required this.timestamp,
  });
}
