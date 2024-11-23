class CardEntity {
  final String cardId;
  final String name;
  final String? description;
  final String? imageUrl;
  final Map<String, dynamic>? additionalData;

  CardEntity({
    required this.cardId,
    required this.name,
    this.description,
    this.imageUrl,
    this.additionalData,
  });
}
