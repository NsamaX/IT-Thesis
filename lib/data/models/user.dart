class UserModel {
  final String userId, email;
  final List<String> tagIds, deckIds, recordIds;

  UserModel({
    required this.userId,
    required this.email,
    required this.tagIds,
    required this.deckIds,
    required this.recordIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      tagIds: List<String>.from(json['tagIds'] ?? []),
      deckIds: List<String>.from(json['deckIds'] ?? []),
      recordIds: List<String>.from(json['recordIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'tagIds': tagIds,
      'deckIds': deckIds,
      'recordIds': recordIds,
    };
  }
}
