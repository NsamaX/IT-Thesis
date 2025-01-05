import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nfc_project/core/exceptions/api.dart';
import '../../../models/card.dart';
import '../game_factory.dart';

class VanguardApi implements GameApi {
  final String baseUrl;

  VanguardApi(this.baseUrl);

  @override
  Future<CardModel> fetchCardsById(String id) async {
    try {
      final url = _buildUrl('cards/$id');
      final response = await _getRequest(url);
      _validateResponse(response);
      final cardData = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return _parseCardData(cardData);
    } catch (e) {
      throw ApiException('Failed to fetch card by ID $id: $e');
    }
  }

  @override
  Future<List<CardModel>> fetchCardsPage(int page) async {
    try {
      final url = _buildUrl('cards', {'page': page.toString()});
      final response = await _getRequest(url);
      _validateResponse(response);
      final body = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>?;
      return data != null ? _filterCardData(data) : [];
    } catch (e) {
      throw ApiException('Failed to fetch cards on page $page: $e');
    }
  }

  Uri _buildUrl(String path, [Map<String, String>? queryParams]) {
    return Uri.parse('$baseUrl/$path').replace(queryParameters: queryParams);
  }

  Future<http.Response> _getRequest(Uri url) async {
    return await http.get(url, headers: {
      'Accept-Encoding': 'gzip',
      'Content-Type': 'application/json',
    });
  }

  void _validateResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiException('API Error: ${response.statusCode}, ${response.reasonPhrase}');
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
