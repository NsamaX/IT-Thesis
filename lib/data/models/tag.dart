class TagModel {
  final String tagId;
  final String cardId;
  final String game;
  final DateTime timestamp;

  TagModel({
    required this.tagId,
    required this.cardId,
    required this.game,
    required this.timestamp,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      tagId: json['tagId'],
      cardId: json['cardId'],
      game: json['game'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'cardId': cardId,
      'game': game,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
