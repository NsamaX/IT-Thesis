class UserEntity {
  final String userId;
  final String email;
  final List<String> deckIds;
  final List<String> recordIds;

  UserEntity({
    required this.userId,
    required this.email,
    required this.deckIds,
    required this.recordIds,
  });

  UserEntity copyWith({
    String? email,
    String? userId,
    List<String>? deckIds,
    List<String>? recordIds,
  }) => UserEntity(
    userId: userId ?? this.userId,
    email: email ?? this.email,
    deckIds: deckIds ?? this.deckIds,
    recordIds: recordIds ?? this.recordIds,
  );
}
