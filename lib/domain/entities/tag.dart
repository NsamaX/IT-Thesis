class TagEntity {
  final String tagId, cardId, game;
  final DateTime timestamp;

  TagEntity({
    required this.tagId,
    required this.cardId,
    required this.game,
    required this.timestamp,
  });

  TagEntity copyWith({
    String? tagId, cardId, game,
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
