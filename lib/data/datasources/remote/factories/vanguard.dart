import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../models/card.dart';
import '../game_factory.dart';

class VanguardApi implements GameApi {
  final String baseUrl;

  VanguardApi(this.baseUrl);

  @override
  Future<CardModel> fetchCardsById(String id) async {
    try {
      final response = await _getRequest(_buildUrl('cards/$id'));
      final cardData = _decodeResponse(response);
      return _parseCardData(cardData);
    } catch (e) {
      throw Exception('Failed to fetch card by ID $id: $e');
    }
  }

  @override
  Future<List<CardModel>> fetchCardsPage(int page) async {
    try {
      final response = await _getRequest(_buildUrl('cards', {'page': page.toString()}));
      final body = _decodeResponse(response);
      final data = body['data'] as List<dynamic>? ?? [];
      return _filterCardData(data);
    } catch (e) {
      throw Exception('Failed to fetch cards on page $page: $e');
    }
  }

  Future<http.Response> _getRequest(Uri url) async {
    final response = await http.get(url, headers: {
      'Accept-Encoding': 'gzip',
      'Content-Type': 'application/json',
    });
    _validateResponse(response);
    return response;
  }

  void _validateResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('API Error: ${response.statusCode}, ${response.reasonPhrase}');
    }
  }

  Uri _buildUrl(String path, [Map<String, String>? queryParams]) =>
      Uri.parse('$baseUrl/$path').replace(queryParameters: queryParams);

  Map<String, dynamic> _decodeResponse(http.Response response) {
    try {
      return json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to decode response: $e');
    }
  }

  List<CardModel> _filterCardData(List<dynamic> cardsData) {
    return cardsData
        .where((card) =>
            card['sets'] != null &&
            card['format'] != 'Vanguard ZERO' &&
            (card['sets'] as List).isNotEmpty)
        .map((cardData) => _parseCardData(cardData))
        .toList();
  }

  CardModel _parseCardData(Map<String, dynamic> cardData) {
    return CardModel(
      cardId: cardData['id']?.toString() ?? '',
      game: 'vanguard',
      name: cardData['name'] ?? '',
      description: cardData['format'] ?? '',
      imageUrl: cardData['imageurljp'] ?? '',
      additionalData: {
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
      },
    );
  }
}
