/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class UserModel {
  final String userId;
  final String email;
  final List<String> deckIds;
  final List<String> recordIds;

  const UserModel({
    required this.userId,
    required this.email,
    required this.deckIds,
    required this.recordIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json['userId'] as String? ?? '',
    email: json['email'] as String? ?? '',
    deckIds: List<String>.from(json['deckIds'] as List<dynamic>? ?? []),
    recordIds: List<String>.from(json['recordIds'] as List<dynamic>? ?? []),
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'userId': userId,
    'deckIds': deckIds,
    'recordIds': recordIds,
  };
}
