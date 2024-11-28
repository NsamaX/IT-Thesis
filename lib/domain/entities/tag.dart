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

  TagEntity copyWith({
    String? tagId,
    String? cardId,
    String? game,
    DateTime? timestamp,
  }) {
    return TagEntity(
      tagId: tagId ?? this.tagId,
      cardId: cardId ?? this.cardId,
      game: game ?? this.game,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
