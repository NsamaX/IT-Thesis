import 'dart:async';
import '../datasources/local/card.dart';
import '../datasources/remote/game_factory.dart';
import '../models/card.dart';

abstract class CardRepository {
  Future<CardModel> fetchCardById(String game, String id);
  Future<List<CardModel>> syncCards(String game);
}

class CardRepositoryImpl implements CardRepository {
  final CardLocalDataSource cardLocalDataSource;
  final GameApi gameApi;

  CardRepositoryImpl({required this.cardLocalDataSource, required this.gameApi});

  @override
  Future<CardModel> fetchCardById(String game, String id) async {
    final localCard = await cardLocalDataSource.fetchCardById(game, id);
    return localCard ?? await gameApi.fetchCardsById(id);
  }

  @override
  Future<List<CardModel>> syncCards(String game) async {
    final stopwatch = Stopwatch()..start();
    final localCards = await cardLocalDataSource.fetchCards(game);
    final localLastPage = await cardLocalDataSource.fetchLastPage(game);
    final remoteLastPage = await _getLastPageFromApi(localLastPage + 1);
    if (localLastPage >= remoteLastPage && localCards.isNotEmpty) {
      return localCards;
    }
    final updatedCards = await _parallelLoadAndSaveCards(
      game,
      startPage: localLastPage + 1,
      endPage: remoteLastPage,
    );
    stopwatch.stop();
    return updatedCards;
  }

  Future<int> _getLastPageFromApi(int startPage, {int batchSize = 30}) async {
    int currentPage = startPage;
    while (true) {
      final batchResults = await Future.wait(
        List.generate(
          batchSize,
          (i) => _fetchCardsPageWithPageNumber(currentPage + i),
        ),
      );
      for (var result in batchResults) {
        final page = result.keys.first;
        final cards = result[page]!;
        if (cards.isEmpty) {
          return page - 1;
        }
      }
      currentPage += batchSize;
    }
  }

  Future<Map<int, List<CardModel>>> _fetchCardsPageWithPageNumber(int page) async {
    try {
      final cards = await gameApi.fetchCardsPage(page);
      return {page: cards};
    } catch (e) {
      return {page: []};
    }
  }

  Future<List<CardModel>> _parallelLoadAndSaveCards(
    String game, {
    required int startPage, 
    required int endPage, 
    int maxConcurrentRequests = 50
  }) async {
    final futures = <Future<void>>[];
    for (int page = startPage; page <= endPage; page++) {
      futures.add(Future.microtask(() => _loadPageAndSave(game, page)));
      if (futures.length >= maxConcurrentRequests || page == endPage) {
        await Future.wait(futures);
        futures.clear();
      }
    }
    return cardLocalDataSource.fetchCards(game);
  }

  Future<void> _loadPageAndSave(String game, int page, {int maxRetries = 3}) async {
    if (await cardLocalDataSource.isPageExists(game, page)) return;
    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        final cards = await gameApi.fetchCardsPage(page);
        if (cards.isNotEmpty) {
          await cardLocalDataSource.saveCards(game, page, cards);
        }
        break;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          print('Failed to load page $page after $maxRetries attempts. Error: $e');
          throw Exception('Failed to load page $page.');
        }
      }
    }
  }
}
