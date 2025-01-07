class TagEntity {
  final String tagId;
  final String cardId;
  final String game;

  TagEntity({
    required this.tagId,
    required this.cardId,
    required this.game,
  });

  TagEntity copyWith({
    String? tagId,
    String? cardId,
    String? game,
  }) {
    return TagEntity(
      tagId: tagId ?? this.tagId,
      cardId: cardId ?? this.cardId,
      game: game ?? this.game,
    );
  }
}
