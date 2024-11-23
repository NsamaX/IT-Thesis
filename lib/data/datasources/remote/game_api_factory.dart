import 'factories/@export.dart';
import 'api_config.dart';

abstract class GameApi {
  Future<Map<String, dynamic>> fetchCard(String cardId);
  Future<List<Map<String, dynamic>>> fetchCardsPage(int page);
  Future<List<Map<String, dynamic>>> fetchAllCards();
}

class GameApiFactory {
  static GameApi createApi(String game) {
    final baseUrl = ApiConfig.getBaseUrl(game);

    switch (game) {
      case 'vanguard':
        return VanguardApi(baseUrl);
      default:
        throw Exception('Unsupported game: $game');
    }
  }
}
