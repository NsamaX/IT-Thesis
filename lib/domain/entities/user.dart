class UserEntity {
  final String userId;
  final String userName;
  final List<String> tagIds;
  final List<String> deckIds;
  final List<String> recordIds;

  UserEntity({
    required this.userId,
    required this.userName,
    required this.tagIds,
    required this.deckIds,
    required this.recordIds,
  });
}
