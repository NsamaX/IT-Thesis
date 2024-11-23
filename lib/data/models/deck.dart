class DeckModel {
  final String deckId;
  final String deckName;
  final List<String> tagIds;

  DeckModel({
    required this.deckId,
    required this.deckName,
    required this.tagIds,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      deckId: json['deckId'],
      deckName: json['deckName'],
      tagIds: List<String>.from(json['tagIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deckId': deckId,
      'deckName': deckName,
      'tagIds': tagIds,
    };
  }
}
