class CardModel {
  final String cardId;
  final String game;
  final String name;
  final String? description;
  final String? imageUrl;
  final Map<String, dynamic>? additionalData;

  CardModel({
    required this.cardId,
    required this.game,
    required this.name,
    this.description,
    this.imageUrl,
    this.additionalData,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardId: json['cardId'] ?? '',
      game: json['game'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
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
      'description': description,
      'imageUrl': imageUrl,
      'additionalData': additionalData,
    };
  }
}
