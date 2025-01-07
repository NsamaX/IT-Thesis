class TagModel {
  final String tagId, cardId, game;

  TagModel({
    required this.tagId,
    required this.cardId,
    required this.game,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      tagId: json['tagId'] ?? '',
      cardId: json['cardId'] ?? '',
      game: json['game'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'cardId': cardId,
      'game': game,
    };
  }
}
