import 'package:nfc_project/core/constants/api_config.dart';
import '../../models/card.dart';
import 'factories/@export.dart';

/*------------------------------------------------------------------------------
 |  Interface GameApi
 |
 |  วัตถุประสงค์:
 |      กำหนดมาตรฐาน API สำหรับดึงข้อมูลการ์ดในแต่ละเกม
 *----------------------------------------------------------------------------*/
abstract class GameApi {

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน fetchCardsById
   |
   |  วัตถุประสงค์:
   |      ใช้สำหรับดึงข้อมูลการ์ดจาก ID ที่ระบุ
   |
   |  พารามิเตอร์:
   |      id (IN) -- รหัสของการ์ดที่ต้องการดึงข้อมูล
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Future<CardModel> ที่มีข้อมูลของการ์ด
   *--------------------------------------------------------------------------*/
  Future<CardModel> fetchCardsById(String id);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน fetchCardsPage
   |
   |  วัตถุประสงค์:
   |      ใช้สำหรับดึงข้อมูลการ์ดแบบแบ่งหน้า
   |
   |  พารามิเตอร์:
   |      page (IN) -- หมายเลขหน้าของข้อมูลการ์ดที่ต้องการเรียกดู
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Future<List<CardModel>> ที่มีข้อมูลของการ์ดทั้งหมดในหน้านั้น
   *--------------------------------------------------------------------------*/
  Future<List<CardModel>> fetchCardsPage(int page);
}

/*------------------------------------------------------------------------------
 |  คลาส GameFactory
 |
 |  วัตถุประสงค์:
 |      ใช้สำหรับสร้างอินสแตนซ์ของ GameApi ตามเกมที่กำหนด
 *----------------------------------------------------------------------------*/
class GameFactory {
  static GameApi createApi(String game) {
    final baseUrl = ApiConfig.getBaseUrl(game);
    if (baseUrl.isEmpty) {
      throw Exception('Base URL for game "$game" is not configured properly.');
    }

    final Map<String, GameApi Function()> apiRegistry = {
      'my_collection': () => DummyApi(),
      'vanguard': () => VanguardApi(baseUrl),
    };

    return apiRegistry[game]?.call() ?? (throw Exception('Unsupported game: $game'));
  }
}
