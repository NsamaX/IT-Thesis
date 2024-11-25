class TagEntity {
  final String tagId;
  final String cardId;
  final String game;
  final DateTime timestamp;

  TagEntity({
    required this.tagId,
    required this.cardId,
    required this.game,
    required this.timestamp,
  });
}
