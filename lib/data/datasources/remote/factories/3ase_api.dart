import 'dart:convert';

import 'package:http/http.dart' as http;

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
abstract class BaseApi {
  final String baseUrl;
  final http.Client client;
  
  static final Map<String, String> defaultHeaders = {
    'Accept-Encoding': 'gzip',
    'Content-Type': 'application/json',
  };

  BaseApi(this.baseUrl, {http.Client? client}) : client = client ?? http.Client();

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<http.Response> getRequest(String path, [Map<String, String>? queryParams]) async {
    final url = buildUrl(path, queryParams);
    try {
      final response = await client.get(url, headers: defaultHeaders);
      validateResponse(response);
      return response;
    } catch (e) {
      throw Exception('Failed to send GET request to $url: $e');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Uri buildUrl(String path, [Map<String, String>? queryParams]) => 
  Uri.parse('$baseUrl/$path').replace(queryParameters: queryParams);

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  void validateResponse(http.Response response) {
    if (response.statusCode != 200) {
      final errorBody = decodeResponse(response);
      throw Exception('API Error: ${response.statusCode}, ${response.reasonPhrase}, Response: $errorBody');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Map<String, dynamic> decodeResponse(http.Response response) {
    try {
      return json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to decode response: $e');
    }
  }
}
