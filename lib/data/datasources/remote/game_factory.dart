import 'package:nfc_project/core/constants/api_config.dart';
import 'package:nfc_project/core/exceptions/factory.dart';
import '../../models/card.dart';
import 'factories/@export.dart';

abstract class GameApi {
  Future<List<CardModel>> fetchCardsPage(int page);
  Future<CardModel> fetchCardsById(int id);
}

class GameFactory {
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
      throw FactoryException('Failed to create API for game "$game"', details: e.toString());
    }
  }
}
