import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class BaseApi {
  final String baseUrl;

  BaseApi(this.baseUrl);

  static const Map<String, String> defaultHeaders = {
    'Accept-Encoding': 'gzip',
    'Content-Type': 'application/json',
  };

  Future<http.Response> getRequest(String path, [Map<String, String>? queryParams]) async {
    final url = buildUrl(path, queryParams);
    try {
      final response = await http.get(url, headers: defaultHeaders);
      validateResponse(response);
      return response;
    } catch (e) {
      throw Exception('Failed to send GET request to $url: $e');
    }
  }

  Uri buildUrl(String path, [Map<String, String>? queryParams]) => Uri.parse('$baseUrl/$path').replace(queryParameters: queryParams);

  void validateResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('API Error: ${response.statusCode}, ${response.reasonPhrase}');
    }
  }

  Map<String, dynamic> decodeResponse(http.Response response) {
    try {
      return json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to decode response: $e');
    }
  }
}
