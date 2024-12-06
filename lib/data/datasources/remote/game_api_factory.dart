import 'package:nfc_project/core/utils/exceptions.dart';
import 'factories/@export.dart';
import 'api_config.dart';
import '../../models/card.dart';

abstract class GameApi {
  Future<List<CardModel>> fetchAllCards();
  Future<List<CardModel>> fetchCardsPage(int page);
  Future<CardModel> fetchCardById(String cardId);
}

class GameApiFactory {
  static GameApi createApi(String game) {
    try {
      final baseUrl = ApiConfig.getBaseUrl(game);
      if (baseUrl.isEmpty) {
        throw FactoryException('Base URL for game "$game" is not configured properly.');
      }
      final apiRegistry = {
        'vanguard': () => VanguardApi(baseUrl),
      };
      if (apiRegistry.containsKey(game)) {
        return apiRegistry[game]!();
      } else {
        throw FactoryException('Unsupported game: $game');
      }
    } catch (e) {
      throw FactoryException('Failed to create API for game "$game": ${e.toString()}');
    }
  }
}
