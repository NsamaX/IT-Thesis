class Settings {
  final String language;

  Settings({
    required this.language,
  });

  Settings copyWith({
    String? language,
  }) {
    return Settings(
      language: language ?? this.language,
    );
  }
}
