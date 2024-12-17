import 'package:flutter/foundation.dart';
import '../datasources/local/card.dart';
import '../datasources/remote/game_factory.dart';
import '../models/card.dart';
import 'dart:async';

abstract class CardRepository {
  Future<List<CardModel>> syncCards(String game);
}

class CardRepositoryImpl implements CardRepository {
  final GameApi gameApi;
  final CardLocalDataSource cardLocalDataSource;

  CardRepositoryImpl({required this.gameApi, required this.cardLocalDataSource});

  @override
  Future<List<CardModel>> syncCards(String game) async {
    final stopwatch = Stopwatch()..start();
    debugPrint('--- Sync Start: Game = $game ---');

    final localCards = await cardLocalDataSource.fetchCards(game);
    debugPrint('Fetched ${localCards.length} cards from local storage.');

    final localLastPage = await cardLocalDataSource.fetchLastPage(game);
    debugPrint('Local Last Page: $localLastPage');

    final remoteLastPage = await _getLastPageFromApi(localLastPage + 1);
    debugPrint('Remote Last Page: $remoteLastPage');

    if (localLastPage >= remoteLastPage && localCards.isNotEmpty) {
      debugPrint('Local data is up-to-date. No sync needed.');
      return localCards;
    }

    debugPrint('Syncing new pages from API...');
    final updatedCards = await _parallelLoadAndSaveCards(game, localLastPage + 1, remoteLastPage);
    debugPrint('Sync completed in ${stopwatch.elapsedMilliseconds} ms');

    return updatedCards;
  }

  Future<int> _getLastPageFromApi(int startPage) async {
    const int batchSize = 30;
    int currentPage = startPage;

    while (true) {
      final batchResults = await Future.wait(
        List.generate(batchSize, (i) => _fetchCardsPageWithPageNumber(currentPage + i)),
      );

      for (var result in batchResults) {
        final page = result.keys.first;
        final cards = result[page]!;

        if (cards.isEmpty) {
          debugPrint('No more cards found on page $page. Last page reached.');
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
      debugPrint('Error fetching page $page: $e');
      return {page: []};
    }
  }

  Future<List<CardModel>> _parallelLoadAndSaveCards(String game, int startPage, int endPage) async {
    const int maxConcurrentRequests = 50;
    final List<Future<void>> futures = [];
    debugPrint('Starting parallel loading and saving...');

    for (int page = startPage; page <= endPage; page++) {
      // ใช้ Future.microtask เพื่อเพิ่ม parallel execution
      futures.add(Future.microtask(() => _loadPageAndSave(game, page)));

      if (futures.length >= maxConcurrentRequests || page == endPage) {
        debugPrint('Processing batch: ${futures.length} pages');
        await Future.wait(futures);
        futures.clear();
      }
    }

    debugPrint('All pages processed.');
    return cardLocalDataSource.fetchCards(game);
  }

  Future<void> _loadPageAndSave(String game, int page) async {
    if (await cardLocalDataSource.isPageExists(game, page)) return;

    const int maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        debugPrint('Loading cards for page $page (attempt ${retryCount + 1})...');
        final cards = await gameApi.fetchCardsPage(page);

        if (cards.isNotEmpty) {
          // บันทึกแบบ Parallel โดยไม่ต้องรอ
          await cardLocalDataSource.saveCards(game, page, cards);
          debugPrint('Saved ${cards.length} cards for page $page.');
        } else {
          debugPrint('No cards found on page $page.');
        }
        break;
      } catch (e) {
        retryCount++;
        debugPrint('Error loading page $page: $e');
        if (retryCount == maxRetries) {
          debugPrint('Failed to load page $page after $maxRetries attempts.');
        }
      }
    }
  }
}
