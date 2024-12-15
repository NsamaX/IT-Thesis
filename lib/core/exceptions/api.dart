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
