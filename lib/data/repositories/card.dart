import 'dart:async';
import '../datasources/local/card.dart';
import '../datasources/remote/game_factory.dart';
import '../models/card.dart';

abstract class CardRepository {
  /// ซิงค์ข้อมูลการ์ดระหว่าง Local Data Source และ Remote API
  Future<List<CardModel>> syncCards(String game);
}

/// การใช้งานจริงของ CardRepository
/// - ใช้สำหรับจัดการการดึงและบันทึกข้อมูลการ์ด
class CardRepositoryImpl implements CardRepository {
  /// API ของเกม
  final GameApi gameApi;

  /// Local Data Source สำหรับการ์ด
  final CardLocalDataSource cardLocalDataSource;

  /// สร้างออบเจ็กต์ CardRepositoryImpl ด้วย GameApi และ CardLocalDataSource
  CardRepositoryImpl({required this.gameApi, required this.cardLocalDataSource});

  //------------------------------- ซิงค์ข้อมูลการ์ด ------------------------------//
  /// ซิงค์ข้อมูลการ์ดระหว่าง Local Data Source และ Remote API
  @override
  Future<List<CardModel>> syncCards(String game) async {
    final stopwatch = Stopwatch()..start();
    final localCards = await cardLocalDataSource.fetchCards(game);
    final localLastPage = await cardLocalDataSource.fetchLastPage(game);
    final remoteLastPage = await _getLastPageFromApi(localLastPage + 1);
    if (localLastPage >= remoteLastPage && localCards.isNotEmpty) {
      return localCards;
    }
    final updatedCards = await _parallelLoadAndSaveCards(game, localLastPage + 1, remoteLastPage);
    stopwatch.stop();
    return updatedCards;
  }

  //---------------------------- ดึงหน้าสุดท้ายจาก API ---------------------------//
  /// ดึงหมายเลขหน้าสุดท้ายของข้อมูลการ์ดจาก Remote API
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
          return page - 1;
        }
      }
      currentPage += batchSize;
    }
  }

  /// ดึงข้อมูลการ์ดจาก Remote API พร้อมระบุหมายเลขหน้า
  Future<Map<int, List<CardModel>>> _fetchCardsPageWithPageNumber(int page) async {
    try {
      final cards = await gameApi.fetchCardsPage(page);
      return {page: cards};
    } catch (e) {
      return {page: []};
    }
  }

  //---------------------------- ซิงค์ข้อมูลแบบคู่ขนาน ----------------------------//
  /// ดึงและบันทึกข้อมูลการ์ดแบบคู่ขนานระหว่าง Local และ Remote
  Future<List<CardModel>> _parallelLoadAndSaveCards(String game, int startPage, int endPage) async {
    const int maxConcurrentRequests = 50;
    final List<Future<void>> futures = [];
    for (int page = startPage; page <= endPage; page++) {
      futures.add(Future.microtask(() => _loadPageAndSave(game, page)));
      if (futures.length >= maxConcurrentRequests || page == endPage) {
        await Future.wait(futures);
        futures.clear();
      }
    }
    return cardLocalDataSource.fetchCards(game);
  }

  /// ดึงข้อมูลจาก Remote API และบันทึกลง Local
  Future<void> _loadPageAndSave(String game, int page) async {
    if (await cardLocalDataSource.isPageExists(game, page)) return;
    const int maxRetries = 3;
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
        if (retryCount == maxRetries) {
          throw Exception('Failed to load page $page after $maxRetries attempts.');
        }
      }
    }
  }
}
