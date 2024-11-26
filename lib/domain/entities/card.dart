class CardEntity {
  final String cardId;
  final String game;
  final String name;
  final String? description;
  final String? imageUrl;
  final Map<String, dynamic>? additionalData;

  CardEntity({
    required this.cardId,
    required this.game,
    required this.name,
    this.description,
    this.imageUrl,
    this.additionalData,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CardEntity &&
        other.cardId == cardId &&
        other.game == game &&
        other.name == name;
  }

  @override
  int get hashCode => cardId.hashCode ^ game.hashCode ^ name.hashCode;
}
