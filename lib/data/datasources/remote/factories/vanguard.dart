import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nfc_project/core/exceptions/api.dart';
import '../game_factory.dart';
import '../../../models/card.dart';

/// API สำหรับเกม Vanguard ที่ใช้สำหรับดึงข้อมูลการ์ด
class VanguardApi implements GameApi {
  /// URL พื้นฐานของ API
  final String baseUrl;

  /// สร้างออบเจ็กต์ VanguardApi ด้วย URL พื้นฐาน
  VanguardApi(this.baseUrl);

  //------------------------------- การสร้าง URL -------------------------------//
  /// สร้าง URL สำหรับการร้องขอ API
  /// - [path]: เส้นทางของ API
  /// - [queryParams]: พารามิเตอร์ที่ต้องการเพิ่มใน URL
  Uri _buildUrl(String path, [Map<String, String>? queryParams]) {
    return Uri.parse('$baseUrl/$path').replace(queryParameters: queryParams);
  }

  //-------------------------- การตรวจสอบการตอบสนอง --------------------------//
  /// ตรวจสอบว่าการตอบสนองจาก API มีสถานะที่ถูกต้องหรือไม่
  /// - หากสถานะไม่ใช่ 200 จะโยนข้อยกเว้น [ApiException]
  void _validateResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiException('API Error: ${response.statusCode}, ${response.reasonPhrase}');
    }
  }

  //------------------------------ การร้องขอ HTTP ------------------------------//
  /// ส่งคำร้องขอ HTTP แบบ GET
  /// - [url]: URL สำหรับคำร้องขอ
  Future<http.Response> _getRequest(Uri url) async {
    return await http.get(url, headers: {
      'Accept-Encoding': 'gzip',
      'Content-Type': 'application/json',
    });
  }

  //----------------------------- การแปลงข้อมูลการ์ด ----------------------------//
  /// แปลงข้อมูล JSON ของการ์ดให้เป็น `CardModel`
  /// - [cardData]: ข้อมูล JSON ของการ์ด
  CardModel _parseCardData(Map<String, dynamic> cardData) {
    return CardModel(
      cardId: cardData['id']?.toString() ?? '',
      game: 'vanguard',
      name: cardData['name'] ?? '',
      description: cardData['format'] ?? '',
      imageUrl: cardData['imageurljp'] ?? '',
      additionalData: {
        'cardType': cardData['cardtype'] ?? '',
        'clan': cardData['clan'] ?? '',
        'effect': cardData['effect'] ?? '',
        'grade': cardData['grade'] ?? '',
        'power': cardData['power'] ?? 0,
        'shield': cardData['shield'] ?? 0,
        'nation': cardData['nation'] ?? '',
        'race': cardData['race'] ?? '',
        'sets': cardData['sets'] ?? [],
        'skill': cardData['skill'] ?? '',
      },
    );
  }

  //----------------------------- การกรองข้อมูลการ์ด -----------------------------//
  /// กรองข้อมูลการ์ดเพื่อเลือกเฉพาะการ์ดที่ผ่านเงื่อนไข
  /// - เงื่อนไข: การ์ดต้องมี `sets` และไม่ใช่ `Vanguard ZERO`
  List<CardModel> _filterCardData(List<dynamic> cardsData) {
    return cardsData
        .where((card) =>
            card['sets'] != null &&
            card['format'] != 'Vanguard ZERO' &&
            (card['sets'] as List).isNotEmpty)
        .map((cardData) => _parseCardData(cardData))
        .toList();
  }

  //------------------------------ การดึงข้อมูลการ์ด -----------------------------//
  /// ดึงข้อมูลการ์ดจาก API โดยระบุหน้า (page)
  /// - [page]: หมายเลขหน้าที่ต้องการดึงข้อมูล
  @override
  Future<List<CardModel>> fetchCardsPage(int page) async {
    try {
      final url = _buildUrl('cards', {'page': page.toString()});
      final response = await _getRequest(url);
      _validateResponse(response);
      final body = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>?;
      return data != null ? _filterCardData(data) : [];
    } catch (e) {
      throw ApiException('Failed to fetch cards on page $page: $e');
    }
  }
}
