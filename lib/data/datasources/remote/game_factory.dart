import 'package:nfc_project/core/constants/api_config.dart';
import '../../models/card.dart';
import 'factories/@export.dart';

abstract class GameApi {
  Future<CardModel> fetchCardsById(String id);
  Future<List<CardModel>> fetchCardsPage(int page);
}

class GameFactory {
  static GameApi createApi(String game) {
    final baseUrl = ApiConfig.getBaseUrl(game);
    if (baseUrl.isEmpty) {
      throw Exception('Base URL for game "$game" is not configured properly.');
    }
    final apiRegistry = <String, GameApi Function()>{
      'vanguard': () => VanguardApi(baseUrl),
    };
    final apiCreator = apiRegistry[game];
    if (apiCreator != null) {
      return apiCreator();
    }
    throw Exception('Unsupported game: $game');
  }
}
