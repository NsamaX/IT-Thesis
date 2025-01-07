class UserEntity {
  final String email;
  final String userId;
  final List<String> tagIds;
  final List<String> deckIds;
  final List<String> recordIds;

  UserEntity({
    required this.email,
    required this.userId,
    required this.tagIds,
    required this.deckIds,
    required this.recordIds,
  });

  UserEntity copyWith({
    String? email,
    String? userId,
    List<String>? tagIds,
    List<String>? deckIds,
    List<String>? recordIds,
  }) {
    return UserEntity(
      email: email ?? this.email,
      userId: userId ?? this.userId,
      tagIds: tagIds ?? this.tagIds,
      deckIds: deckIds ?? this.deckIds,
      recordIds: recordIds ?? this.recordIds,
    );
  }
}
