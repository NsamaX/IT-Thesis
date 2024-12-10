import 'package:nfc_project/core/utils/api_config.dart';
import 'package:nfc_project/core/utils/exceptions.dart';
import 'factories/@export.dart';
import '../../models/card.dart';

abstract class GameApi {
  Future<List<CardModel>> fetchAllCards();
  Future<List<CardModel>> fetchCardsPage(int page);
  Future<CardModel> fetchCardById(String cardId);
}

class GameFactory {
  static GameApi createApi(String game) {
    try {
      final baseUrl = ApiConfig.getBaseUrl(game);
      if (baseUrl.isEmpty) {
        throw GameApiException('Base URL for game "$game" is not configured properly.');
      }
      final apiRegistry = {
        'vanguard': () => VanguardApi(baseUrl),
      };
      if (apiRegistry.containsKey(game)) {
        return apiRegistry[game]!();
      } else {
        throw GameApiException('Unsupported game: $game');
      }
    } catch (e) {
      throw GameApiException('Failed to create API for game "$game"', details: e.toString());
    }
  }
}
