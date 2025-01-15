import 'package:nfc_project/core/constants/api_config.dart';
import '../../../models/card.dart';
import '../game_factory.dart';
import '3ase_api.dart';

class VanguardApi extends BaseApi implements GameApi {
  VanguardApi(String baseUrl) : super(baseUrl);

  @override
  Future<CardModel> fetchCardsById(String id) async {
    final response = await getRequest('cards/$id');
    final cardData = decodeResponse(response);
    return _parseCardData(cardData);
  }

  @override
  Future<List<CardModel>> fetchCardsPage(int page) async {
    final response = await getRequest('cards', {'page': page.toString()});
    final body = decodeResponse(response);
    final data = body['data'] as List<dynamic>? ?? [];
    return _filterCardData(data);
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
