class CardModel {
  final String cardId;
  final String game;
  final String name;
  final String? imageUrl; 
  final String? description;
  final Map<String, dynamic>? additionalData;

  const CardModel({
    required this.cardId,
    required this.game,
    required this.name,
    this.imageUrl,
    this.description,
    this.additionalData,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
    cardId: json['cardId'] as String? ?? '',
    game: json['game'] as String? ?? '',
    name: json['name'] as String? ?? '',
    imageUrl: json['imageUrl'] as String?,
    description: json['description'] as String?,
    additionalData: (json['additionalData'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(key, value),
    ),
  );


  Map<String, dynamic> toJson() => {
    'cardId': cardId,
    'game': game,
    'name': name,
    'imageUrl': imageUrl,
    'description': description,
    'additionalData': additionalData,
  };
}
