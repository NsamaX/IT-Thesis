class LocalDataException implements Exception {
  final String message;
  final String? details;

  LocalDataException(this.message, {this.details});

  @override
  String toString() {
    String result = 'LocalDataException: $message';
    if (details != null) result += ' (Details: $details)';
    return result;
  }
}
