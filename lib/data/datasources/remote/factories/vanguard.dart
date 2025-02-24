import '../../../models/card.dart';
import '../game_factory.dart';
import '3ase_api.dart';

/*------------------------------------------------------------------------------
 |  คลาส VanguardApi
 |
 |  วัตถุประสงค์:
 |      เป็น API สำหรับเรียกข้อมูลการ์ดเกม Vanguard
 *----------------------------------------------------------------------------*/
class VanguardApi extends BaseApi implements GameApi {
  VanguardApi(String baseUrl) : super(baseUrl);

  @override
  Future<CardModel> fetchCardsById(String id) async {
    final response = await getRequest('cards/$id');
    final cardData = decodeResponse(response);
    return _parseCardData(cardData);
  }

  @override
  Future<List<CardModel>> fetchCardsPage(int page) async {
    final response = await getRequest('cards', {'page': page.toString()});
    final body = decodeResponse(response);
    final List<dynamic> data = body['data'] ?? [];
    return _filterCardData(data);
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _filterCardData
   |
   |  วัตถุประสงค์:
   |      กรองข้อมูลการ์ดที่มีข้อมูลครบถ้วน และไม่ใช่การ์ดจากเกม "Vanguard ZERO"
   |
   |  พารามิเตอร์:
   |      cardsData (IN) -- ข้อมูลการ์ดทั้งหมดที่ดึงมา
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น List<CardModel> ที่ผ่านการกรองแล้ว
   *--------------------------------------------------------------------------*/
  List<CardModel> _filterCardData(List<dynamic> cardsData) => cardsData
      .where((card) =>
          card['sets'] != null &&
          card['format'] != 'Vanguard ZERO' &&
          (card['sets'] as List).isNotEmpty)
      .map((cardData) => _parseCardData(cardData))
      .toList();

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _parseCardData
   |
   |  วัตถุประสงค์:
   |      แปลงข้อมูล JSON ที่ได้จาก API ให้เป็นอ็อบเจ็กต์ `CardModel`
   |
   |  พารามิเตอร์:
   |      cardData (IN) -- ข้อมูล JSON ของการ์ด
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น CardModel ที่มีข้อมูลของการ์ด
   *--------------------------------------------------------------------------*/
  CardModel _parseCardData(Map<String, dynamic> cardData) => CardModel(
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
      'sets': (cardData['sets'] as List<dynamic>?)?.cast<String>() ?? [],
      'skill': cardData['skill'] ?? '',
    },
  );
}
