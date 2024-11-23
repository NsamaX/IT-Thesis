class UserModel {
  final String userId;
  final String userName;
  final List<String> tagIds;
  final List<String> deckIds;
  final List<String> recordIds;

  UserModel({
    required this.userId,
    required this.userName,
    required this.tagIds,
    required this.deckIds,
    required this.recordIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['userName'],
      tagIds: List<String>.from(json['tagIds'] ?? []),
      deckIds: List<String>.from(json['deckIds'] ?? []),
      recordIds: List<String>.from(json['recordIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'tagIds': tagIds,
      'deckIds': deckIds,
      'recordIds': recordIds,
    };
  }
}
