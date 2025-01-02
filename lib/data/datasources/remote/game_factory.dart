import 'package:nfc_project/core/constants/api_config.dart';
import 'package:nfc_project/core/exceptions/factory.dart';
import 'factories/@export.dart';
import '../../models/card.dart';

abstract class GameApi {
  /// ดึงข้อมูลการ์ดในหน้าที่ระบุ
  Future<List<CardModel>> fetchCardsPage(int page);
}

/// โรงงานสำหรับสร้าง API ของเกม
class GameFactory {
  /// สร้างอินสแตนซ์ของ GameApi ตามเกมที่ระบุ
  /// - [game]: ชื่อเกม เช่น "vanguard"
  /// - ใช้ `ApiConfig` เพื่อตรวจสอบ Base URL ของเกม
  /// - หากเกมไม่ได้รับการสนับสนุน จะโยนข้อยกเว้น [FactoryException]
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
