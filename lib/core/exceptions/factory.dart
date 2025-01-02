class FactoryException implements Exception {
  final String message;
  final String? details;

  FactoryException(this.message, {this.details});

  @override
  String toString() {
    String result = 'FactoryException: $message';
    if (details != null) result += ' (Details: $details)';
    return result;
  }
}
