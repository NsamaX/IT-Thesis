import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nfc_project/core/utils/exceptions.dart';
import '../game_factory.dart';
import '../../../models/card.dart';

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
      throw ApiException('API Error: ${response.statusCode}, ${response.reasonPhrase}');
    }
  }

  CardModel _parseCardData(Map<String, dynamic> cardData) {
    if (cardData.isEmpty) {
      throw ApiException('Card data is empty or invalid.');
    }
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

  List<CardModel> _filterCardData(List<dynamic> cardsData) {
    return cardsData
        .map((cardData) => _parseCardData(cardData))
        .where((card) => card.additionalData!['sets'] != null && (card.additionalData!['sets'] as List).isNotEmpty)
        .toList();
  }

  @override
  Future<List<CardModel>> fetchAllCards() async {
    try {
      final url = _buildUrl('cards');
      final response = await http.get(url);
      _validateResponse(response);
      final body = json.decode(response.body) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>?;
      if (data == null || data.isEmpty) {
        throw ApiException('No cards available.');
      }
      return _filterCardData(data);
    } catch (e) {
      throw ApiException('Failed to fetch all cards: $e');
    }
  }

  @override
  Future<List<CardModel>> fetchCardsPage(int page) async {
    try {
      final url = _buildUrl('cards', {'page': page.toString()});
      final response = await http.get(url);
      _validateResponse(response);
      final body = json.decode(response.body) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>?;
      if (data == null || data.isEmpty) {
        throw ApiException('No cards found for page $page.');
      }
      return _filterCardData(data);
    } catch (e) {
      throw ApiException('Failed to fetch cards on page $page: $e');
    }
  }

  @override
  Future<CardModel> fetchCardById(String cardId) async {
    try {
      final url = _buildUrl('card', {'id': cardId});
      final response = await http.get(url);
      _validateResponse(response);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data.isEmpty) {
        throw ApiException('No card found with id $cardId.');
      }
      return _parseCardData(data);
    } catch (e) {
      throw ApiException('Failed to fetch card with id $cardId: $e');
    }
  }
}
