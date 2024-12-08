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

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? url;

  ApiException(this.message, {this.statusCode, this.url});

  @override
  String toString() {
    String result = 'ApiException: $message';
    if (statusCode != null) result += ' (Status Code: $statusCode)';
    if (url != null) result += ' (URL: $url)';
    return result;
  }
}

class GameApiException implements Exception {
  final String message;
  final String? details;

  GameApiException(this.message, {this.details});

  @override
  String toString() {
    String result = 'GameApiException: $message';
    if (details != null) result += ' (Details: $details)';
    return result;
  }
}
