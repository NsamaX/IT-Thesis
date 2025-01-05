class UserEntity {
  final String userId, email;
  final List<String> tagIds, deckIds, recordIds;

  UserEntity({
    required this.userId,
    required this.email,
    required this.tagIds,
    required this.deckIds,
    required this.recordIds,
  });

  UserEntity copyWith({
    String? userId, email,
    List<String>? tagIds, deckIds, recordIds,
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
