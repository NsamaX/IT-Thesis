import 'dart:convert';
import 'package:http/http.dart' as http;
import '../game_api_factory.dart';

class VanguardApi implements GameApi {
  final String baseUrl;

  VanguardApi(this.baseUrl);

  Uri _buildUrl(String path, [Map<String, String>? queryParams]) {
    final uri = Uri.parse('$baseUrl/$path');
    return queryParams != null
        ? uri.replace(queryParameters: queryParams)
        : uri;
  }

  void _validateResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception(
          'API Error: ${response.statusCode}, ${response.reasonPhrase}');
    }
  }

  Map<String, dynamic> _parseCardData(Map<String, dynamic> cardData) {
    return {
      'cardId': cardData['id']?.toString() ?? '',
      'name': cardData['name'] ?? '',
      'description': cardData['format'] ?? '',
      'imageUrl': cardData['imageurljp'] ?? '',
      'additionalData': {
        'cardType': cardData['cardtype'] ?? '',
        'clan': cardData['clan'] ?? '',
        'effect': cardData['effect'] ?? '',
        'grade': cardData['grade'] ?? '',
        'power': cardData['power'] ?? 0,
        'shield': cardData['shield'] ?? 0,
        'nation': cardData['nation'] ?? '',
        'race': cardData['race'] ?? '',
        'sets': cardData['sets'] ?? [],
        'skill': cardData['skill'] ?? '',
      }
    };
  }

  @override
  Future<Map<String, dynamic>> fetchCard(String cardId) async {
    final url = _buildUrl('card', {'id': cardId});
    final response = await http.get(url);

    _validateResponse(response);

    final data = json.decode(response.body) as Map<String, dynamic>;
    return _parseCardData(data);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCardsPage(int page) async {
    final url = _buildUrl('cards', {'page': page.toString()});
    final response = await http.get(url);

    _validateResponse(response);

    final body = json.decode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;

    return data.map((cardData) => _parseCardData(cardData)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllCards() async {
    final url = _buildUrl('cards');
    final response = await http.get(url);

    _validateResponse(response);

    final body = json.decode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return data.map((cardData) => _parseCardData(cardData)).toList();
  }
}
