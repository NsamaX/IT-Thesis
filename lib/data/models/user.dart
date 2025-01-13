class UserModel {
  final String email;
  final String userId;
  final List<String> deckIds;
  final List<String> recordIds;

  UserModel({
    required this.email,
    required this.userId,
    required this.deckIds,
    required this.recordIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      deckIds: List<String>.from(json['deckIds'] as List<dynamic>? ?? []),
      recordIds: List<String>.from(json['recordIds'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'userId': userId,
      'deckIds': deckIds,
      'recordIds': recordIds,
    };
  }
}
