import 'dart:convert';
import 'package:flutter/services.dart';

class ApiConfig {
  static late String currentEnvironment;
  static late Map<String, String> baseUrls;
  
  static const String _configPath = 'assets/configs/api.json';

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน loadConfig
   |
   |  วัตถุประสงค์:
   |      โหลดค่าการตั้งค่า API จากไฟล์ JSON ที่อยู่ใน 
   |      "assets/configs/api.json" และกำหนดค่า base URLs 
   |      ให้ตรงกับ environment ที่เลือก
   |
   |  พารามิเตอร์:
   |      environment (IN) -- ชื่อ environment ที่ต้องการโหลด 
   |                          เช่น 'development' หรือ 'production'
   |
   |  ค่าที่คืนกลับ: ไม่มี (แต่จะกำหนดค่าตัวแปร `currentEnvironment` และ `baseUrls`)
   *--------------------------------------------------------------------------*/
  static Future<void> loadConfig({String environment = 'development'}) async {
    try {
      final String jsonString = await rootBundle.loadString(_configPath);
      final Map<String, dynamic> config = json.decode(jsonString);
      
      final environments = config['environments'] as Map<String, dynamic>?;
      if (environments == null || environments[environment] == null) {
        throw Exception('Environment "$environment" not found in file $_configPath');
      }

      currentEnvironment = environment;
      baseUrls = Map<String, String>.from(environments[environment] as Map);
    } catch (e) {
      throw Exception('Failed to load API settings: ${e.toString()}');
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน getBaseUrl
   |
   |  วัตถุประสงค์:
   |      คืนค่า base URL ตาม key ที่กำหนด โดยอ้างอิงจาก environment
   |      ที่ถูกโหลดไว้ในปัจจุบัน
   |
   |  พารามิเตอร์:
   |      key (IN) -- คีย์ที่ใช้ดึงค่า base URL จากการตั้งค่า
   |
   |  ค่าที่คืนกลับ: คืนค่า base URL เป็น string
   |      หากไม่พบคีย์ที่ต้องการ จะเกิด Exception
   *--------------------------------------------------------------------------*/
  static String getBaseUrl(String key) => baseUrls[key] ?? (
    throw Exception('Base URL not found for key "$key" in Environment "$currentEnvironment"')
  );
}
