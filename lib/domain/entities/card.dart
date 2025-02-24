/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class CardEntity {
  final String cardId;
  final String game;
  final String name;
  final String? description;
  final String? imageUrl;
  final Map<String, dynamic>? additionalData;

  const CardEntity({
    required this.cardId,
    required this.game,
    required this.name,
    this.description,
    this.imageUrl,
    this.additionalData,
  });

  CardEntity copyWith({
    String? cardId,
    String? game,
    String? name,
    String? description,
    String? imageUrl,
    Map<String, dynamic>? additionalData,
  }) => CardEntity(
    cardId: cardId ?? this.cardId,
    game: game ?? this.game,
    name: name ?? this.name,
    description: description ?? this.description,
    imageUrl: imageUrl ?? this.imageUrl,
    additionalData: additionalData ?? this.additionalData,
  );
}
