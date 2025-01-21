class UserEntity {
  final String email;
  final String userId;
  final List<String> deckIds;
  final List<String> recordIds;

  UserEntity({
    required this.email,
    required this.userId,
    required this.deckIds,
    required this.recordIds,
  });

  UserEntity copyWith({
    String? email,
    String? userId,
    List<String>? deckIds,
    List<String>? recordIds,
  }) => UserEntity(
    email: email ?? this.email,
    userId: userId ?? this.userId,
    deckIds: deckIds ?? this.deckIds,
    recordIds: recordIds ?? this.recordIds,
  );
}
