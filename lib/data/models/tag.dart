class TagModel {
  final String tagId;
  final String cardId;
  final String game;

  TagModel({
    required this.tagId,
    required this.cardId,
    required this.game,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      tagId: json['tagId'] as String? ?? '',
      cardId: json['cardId'] as String? ?? '',
      game: json['game'] as String? ?? '',
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
