class UserEntity {
  final String userId;
  final String email;
  final List<String> tagIds;
  final List<String> deckIds;
  final List<String> recordIds;

  UserEntity({
    required this.userId,
    required this.email,
    required this.tagIds,
    required this.deckIds,
    required this.recordIds,
  });

  UserEntity copyWith({
    String? userId,
    String? email,
    List<String>? tagIds,
    List<String>? deckIds,
    List<String>? recordIds,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      tagIds: tagIds ?? this.tagIds,
      deckIds: deckIds ?? this.deckIds,
      recordIds: recordIds ?? this.recordIds,
    );
  }
}
