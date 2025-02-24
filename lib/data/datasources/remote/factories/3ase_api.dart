import 'package:http/http.dart' as http;
import 'dart:convert';

/*------------------------------------------------------------------------------
 |  Abstract Class BaseApi
 |
 |  วัตถุประสงค์:
 |      เป็นคลาสหลักสำหรับการเรียก API โดยใช้ HTTP Client
 |      - รองรับ GET Request
 |      - มีการตรวจสอบสถานะ Response
 |      - มีการแปลง Response ให้อยู่ในรูปแบบ JSON
 *----------------------------------------------------------------------------*/
abstract class BaseApi {
  final String baseUrl;
  final http.Client client;

  /*----------------------------------------------------------------------------
   |  คอนสตรักเตอร์ BaseApi
   |
   |  วัตถุประสงค์:
   |      กำหนดค่า `baseUrl` และรองรับการใช้ `http.Client` สำหรับการเรียก API
   |
   |  พารามิเตอร์:
   |      baseUrl (IN) -- URL พื้นฐานของ API
   |      client (IN) -- HTTP Client ที่ใช้สำหรับเรียก API (ใช้สำหรับ Dependency Injection)
   *--------------------------------------------------------------------------*/
  BaseApi(this.baseUrl, {http.Client? client}) : client = client ?? http.Client();
  static final Map<String, String> defaultHeaders = {
    'Accept-Encoding': 'gzip',
    'Content-Type': 'application/json',
  };

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน getRequest
   |
   |  วัตถุประสงค์:
   |      ใช้สำหรับเรียก API ด้วย GET Request
   |
   |  พารามิเตอร์:
   |      path (IN) -- พาธของ API ที่ต้องการเรียก
   |      queryParams (IN) -- พารามิเตอร์แบบ Query String (ถ้ามี)
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Future<http.Response> ที่มีข้อมูลจาก API
   *--------------------------------------------------------------------------*/
  Future<http.Response> getRequest(String path, [Map<String, String>? queryParams]) async {
    final url = buildUrl(path, queryParams);
    try {
      final response = await client.get(url, headers: defaultHeaders);
      validateResponse(response);
      return response;
    } catch (e) {
      throw Exception('Failed to send GET request to $url: $e');
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน buildUrl
   |
   |  วัตถุประสงค์:
   |      สร้าง URL สำหรับการเรียก API โดยรองรับ Query Parameters
   |
   |  พารามิเตอร์:
   |      path (IN) -- พาธของ API ที่ต้องการเรียก
   |      queryParams (IN) -- พารามิเตอร์แบบ Query String (ถ้ามี)
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Uri ที่ใช้ในการเรียก API
   *--------------------------------------------------------------------------*/
  Uri buildUrl(String path, [Map<String, String>? queryParams]) => 
  Uri.parse('$baseUrl/$path').replace(queryParameters: queryParams);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน validateResponse
   |
   |  วัตถุประสงค์:
   |      ตรวจสอบ Response จาก API และโยน Exception ถ้าสถานะไม่ใช่ 200
   |
   |  พารามิเตอร์:
   |      response (IN) -- Response จาก API
   |
   |  ค่าที่คืนกลับ:
   |      - ไม่มีค่าคืนกลับ แต่จะโยน Exception หาก API มีปัญหา
   *--------------------------------------------------------------------------*/
  void validateResponse(http.Response response) {
    if (response.statusCode != 200) {
      final errorBody = decodeResponse(response);
      throw Exception('API Error: ${response.statusCode}, ${response.reasonPhrase}, Response: $errorBody');
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน decodeResponse
   |
   |  วัตถุประสงค์:
   |      แปลง Response Body จาก JSON เป็น Map
   |
   |  พารามิเตอร์:
   |      response (IN) -- Response จาก API
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Map<String, dynamic> ที่ได้จาก JSON
   *--------------------------------------------------------------------------*/
  Map<String, dynamic> decodeResponse(http.Response response) {
    try {
      return json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to decode response: $e');
    }
  }
}
