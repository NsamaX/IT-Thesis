import '../../../models/card.dart';
import '../game_factory.dart';

/*------------------------------------------------------------------------------
 |  คลาส DummyApi
 |
 |  วัตถุประสงค์:
 |      ใช้เป็น API จำลองสำหรับการทดสอบ โดยไม่มีการดึงข้อมูลจริง
 *----------------------------------------------------------------------------*/
class DummyApi implements GameApi {
  @override
  Future<CardModel> fetchCardsById(String id) async {
    throw UnsupportedError('Dummy API does not support fetching cards.');
  }

  @override
  Future<List<CardModel>> fetchCardsPage(int page) async {
    throw UnsupportedError('Dummy API does not support pagination.');
  }
}
