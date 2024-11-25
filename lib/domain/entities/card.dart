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
}
