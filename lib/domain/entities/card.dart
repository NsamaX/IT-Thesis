class CardEntity {
  final String cardId, game, name;
  final String? description, imageUrl;
  final Map<String, dynamic>? additionalData;

  CardEntity({
    required this.cardId,
    required this.game,
    required this.name,
    this.description,
    this.imageUrl,
    this.additionalData,
  });

  CardEntity copyWith({
    String? cardId, game, name, description, imageUrl,
    Map<String, dynamic>? additionalData,
  }) {
    return CardEntity(
      cardId: cardId ?? this.cardId,
      game: game ?? this.game,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}
