class TagModel {
  final String tagId;
  final String game;
  final String cardId;
  final DateTime timestamp;

  TagModel({
    required this.tagId,
    required this.game,
    required this.cardId,
    required this.timestamp,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      tagId: json['tagId'],
      game: json['game'],
      cardId: json['cardId'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'game': game,
      'cardId': cardId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
