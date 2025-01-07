class CardModel {
  final String cardId, game, name;
  final String? imageUrl, description;
  final Map<String, dynamic>? additionalData;

  CardModel({
    required this.cardId,
    required this.game,
    required this.name,
    this.imageUrl,
    this.description,
    this.additionalData,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardId: json['cardId'] as String? ?? '',
      game: json['game'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      additionalData: (json['additionalData'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardId': cardId,
      'game': game,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'additionalData': additionalData,
    };
  }
}
