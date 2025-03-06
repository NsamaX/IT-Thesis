class TagModel {
  final String tagId;
  final String cardId;
  final String game;

  const TagModel({
    required this.tagId,
    required this.cardId,
    required this.game,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
    tagId: json['tagId'] as String? ?? '',
    cardId: json['cardId'] as String? ?? '',
    game: json['game'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'tagId': tagId,
    'cardId': cardId,
    'game': game,
  };
}
