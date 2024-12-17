import 'package:flutter/foundation.dart';
import '../datasources/local/card.dart';
import '../datasources/remote/game_factory.dart';
import '../models/card.dart';

abstract class CardRepository {
  Future<List<CardModel>> syncCards(String game);
}

class CardRepositoryImpl implements CardRepository {
  final GameApi gameApi;
  final CardLocalDataSource cardLocalDataSource;

  CardRepositoryImpl({required this.gameApi, required this.cardLocalDataSource});

  @override
  Future<List<CardModel>> syncCards(String game) async {
    // โหลดข้อมูลจาก Local
    final localCards = await cardLocalDataSource.fetchCards(game);
    final localLastPage = await cardLocalDataSource.fetchLastPage(game);
    debugPrint('Local Last Page: $localLastPage');

    // ดึงข้อมูลหน้าสุดท้ายจาก Remote API
    final remoteLastPage = await _getLastPageFromApi(localCards.isEmpty ? 1 : localLastPage + 1);
    debugPrint('Remote Last Page: $remoteLastPage');

    if (localLastPage >= remoteLastPage && localCards.isNotEmpty) {
      // ข้อมูลใน Local ครบถ้วนแล้ว
      debugPrint('Local data is up-to-date. Returning local cards.');
      debugPrint('Local Last Page: $localLastPage, Remote Last Page: $remoteLastPage');
      return localCards;
    }

    // Sync ข้อมูลที่ขาด
    return await _loadAndSaveCards(game, localLastPage + 1, remoteLastPage);
  }

  Future<int> _getLastPageFromApi(int page) async {
    while (true) {
      try {
        final cards = await gameApi.fetchCardsPage(page);
        if (cards.isEmpty) break;
        debugPrint('Fetched ${cards.length} cards from API for page $page');
        page++;
      } catch (e) {
        debugPrint('Failed to fetch page $page: $e');
        break;
      }
    }
    return page - 1;
  }

  Future<List<CardModel>> _loadAndSaveCards(String game, int startPage, int endPage) async {
    final List<CardModel> allCards = [];

    for (int page = startPage; page <= endPage; page++) {
      try {
        // เช็คว่าข้อมูลหน้าปัจจุบันมีอยู่ใน Local แล้วหรือไม่
        if (await cardLocalDataSource.isPageExists(game, page)) {
          debugPrint('Page $page already exists in Local Database. Skipping API call.');
          continue;
        }

        // โหลดจาก API และบันทึกลง Database
        final cardsFromApi = await gameApi.fetchCardsPage(page);
        if (cardsFromApi.isEmpty) break;

        await cardLocalDataSource.saveCards(game, page, cardsFromApi);
        final updatedCards = await cardLocalDataSource.fetchCards(game);
        debugPrint('Cards in Local Database after save: ${updatedCards.length}');

        allCards.addAll(cardsFromApi);
        debugPrint('Synced ${cardsFromApi.length} cards for page $page');
      } catch (e) {
        debugPrint('Failed to sync page $page: $e');
      }
    }
    return allCards;
  }
}
