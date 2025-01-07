class UserModel {
  final String userId;
  final String email;
  final List<String> tagIds;
  final List<String> deckIds;
  final List<String> recordIds;

  UserModel({
    required this.userId,
    required this.email,
    required this.tagIds,
    required this.deckIds,
    required this.recordIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      tagIds: List<String>.from(json['tagIds'] as List<dynamic>? ?? []),
      deckIds: List<String>.from(json['deckIds'] as List<dynamic>? ?? []),
      recordIds: List<String>.from(json['recordIds'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'tagIds': tagIds,
    'deckIds': deckIds,
    'recordIds': recordIds,
  };
}
