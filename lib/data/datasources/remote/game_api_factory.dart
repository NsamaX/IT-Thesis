import 'factories/@export.dart';
import 'api_config.dart';
import '../../models/card.dart';

abstract class GameApi {
  Future<CardModel> fetchCard(String cardId);
  Future<List<CardModel>> fetchCardsPage(int page);
  Future<List<CardModel>> fetchAllCards();
}

class GameApiFactory {
  static GameApi createApi(String game) {
    try {
      final baseUrl = ApiConfig.getBaseUrl(game);
      if (baseUrl.isEmpty) {
        throw Exception(
            'Base URL for game "$game" is not configured properly.');
      }
      final apiRegistry = {
        'vanguard': () => VanguardApi(baseUrl),
      };
      if (apiRegistry.containsKey(game)) {
        return apiRegistry[game]!();
      } else {
        throw Exception('Unsupported game: $game');
      }
    } catch (e) {
      throw Exception('Failed to create API for game "$game": $e');
    }
  }
}
