import 'dart:async';
import 'package:flutter/foundation.dart';
import '../datasources/local/card.dart';
import '../datasources/local/collection.dart';
import '../datasources/remote/game_factory.dart';
import '../models/card.dart';

abstract class CardRepository {
  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน fetchCardById
   |
   |  วัตถุประสงค์:
   |      ค้นหาการ์ดตาม ID โดยดึงจาก local storage ก่อน
   |      ถ้าไม่พบจะไปดึงจาก API
   |
   |  พารามิเตอร์:
   |      game (IN) -- ชื่อของเกม
   |      id (IN) -- รหัสของการ์ดที่ต้องการดึงข้อมูล
   |
   |  ค่าที่คืนกลับ: Future<CardModel> (การ์ดที่ค้นพบ)
   *--------------------------------------------------------------------------*/
  Future<CardModel> fetchCardById(String game, String id);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน syncCards
   |
   |  วัตถุประสงค์:
   |      ดึงข้อมูลการ์ดทั้งหมดจาก API และซิงค์เข้ากับ local storage
   |
   |  พารามิเตอร์:
   |      game (IN) -- ชื่อของเกมที่ต้องการซิงค์การ์ด
   |
   |  ค่าที่คืนกลับ: Future<List<CardModel>> (รายการการ์ดที่ซิงค์แล้ว)
   *--------------------------------------------------------------------------*/
  Future<List<CardModel>> syncCards(String game);
}

class CardRepositoryImpl implements CardRepository {
  final CardLocalDataSource cardDatasource;
  final CollectionLocalDataSource collectionDatasource;
  final GameApi gameApi;

  CardRepositoryImpl({
    required this.cardDatasource,
    required this.collectionDatasource,
    required this.gameApi,
  });

  @override
  Future<CardModel> fetchCardById(String game, String id) async {
    return await cardDatasource.fetchCardById(game, id) ??
        await gameApi.fetchCardsById(id);
  }

  @override
  Future<List<CardModel>> syncCards(String game) async {
    if (game == "my_collection") {
      return collectionDatasource.fetchCollection();
    }

    final stopwatch = Stopwatch()..start();
    final localCards = await cardDatasource.fetchCards(game);
    final localLastPage = await cardDatasource.fetchLastPage(game);
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
    debugPrint('Sync completed in ${stopwatch.elapsedMilliseconds} ms');
    return updatedCards;
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _getLastPageFromApi
   |
   |  วัตถุประสงค์:
   |      ค้นหาหมายเลขหน้าสุดท้ายที่มีข้อมูลจาก API
   |
   |  ค่าที่คืนกลับ: Future<int> (หมายเลขหน้าสุดท้าย)
   *--------------------------------------------------------------------------*/
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

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _fetchCardsPageWithPageNumber
   |
   |  วัตถุประสงค์:
   |      ดึงข้อมูลการ์ดตามหมายเลขหน้าที่ระบุจาก API
   |
   |  ค่าที่คืนกลับ: Future<Map<int, List<CardModel>>> (หน้าที่ดึงมาและรายการการ์ด)
   *--------------------------------------------------------------------------*/
  Future<Map<int, List<CardModel>>> _fetchCardsPageWithPageNumber(int page) async {
    try {
      return {page: await gameApi.fetchCardsPage(page)};
    } catch (e) {
      return {page: []};
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _parallelLoadAndSaveCards
   |
   |  วัตถุประสงค์:
   |      ดึงข้อมูลการ์ดจาก API และบันทึกลง local storage แบบขนาน
   |
   |  ค่าที่คืนกลับ: Future<List<CardModel>> (รายการการ์ดที่ถูกบันทึกแล้ว)
   *--------------------------------------------------------------------------*/
  Future<List<CardModel>> _parallelLoadAndSaveCards(
    String game, {
    required int startPage,
    required int endPage,
    int maxConcurrentRequests = 50,
  }) async {
    final futures = <Future<void>>[];
    for (int page = startPage; page <= endPage; page++) {
      futures.add(Future.microtask(() => _loadPageAndSave(game, page)));
      if (futures.length >= maxConcurrentRequests || page == endPage) {
        await Future.wait(futures);
        futures.clear();
      }
    }
    return cardDatasource.fetchCards(game);
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _loadPageAndSave
   |
   |  วัตถุประสงค์:
   |      โหลดข้อมูลการ์ดจาก API ตามหน้าที่กำหนด และบันทึกลง local storage
   |
   |  ค่าที่คืนกลับ: Future<void>
   *--------------------------------------------------------------------------*/
  Future<void> _loadPageAndSave(String game, int page, {int maxRetries = 3}) async {
    if (await cardDatasource.isPageExists(game, page)) return;

    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        final cards = await gameApi.fetchCardsPage(page);
        if (cards.isNotEmpty) {
          await cardDatasource.saveCards(game, page, cards);
        }
        break;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          debugPrint('Failed to load page $page after $maxRetries retries.');
        }
      }
    }
  }
}
