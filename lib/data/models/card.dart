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
      cardId: json['cardId'] ?? '',
      game: json['game'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      description: json['description'],
      additionalData: json['additionalData'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['additionalData'])
          : null,
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
