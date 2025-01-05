import 'dart:convert';
import 'package:flutter/services.dart';
import '../exceptions/local_data.dart';

class ApiConfig {
  static String? currentEnvironment;
  static Map<String, String>? baseUrls;

  static Future<void> loadConfig({String environment = 'development'}) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/configs/api.json');
      final Map<String, dynamic> config = json.decode(jsonString);
      final environments = config['environments'] as Map<String, dynamic>?;
      if (environments == null || environments[environment] == null) {
        throw LocalDataException('ไม่พบ environment "$environment" ในไฟล์ api.json');
      }
      currentEnvironment = environment;
      baseUrls = Map<String, String>.from(environments[environment] as Map);
    } catch (e) {
      throw LocalDataException('ไม่สามารถโหลดการตั้งค่า API ได้', details: e.toString());
    }
  }

  static String getBaseUrl(String key) {
    if (baseUrls == null) {
      throw LocalDataException('ยังไม่ได้โหลดการตั้งค่า API กรุณาเรียกใช้ loadConfig() ก่อนเรียก getBaseUrl().');
    }
    return baseUrls?[key] ?? (throw LocalDataException('ไม่พบ Base URL สำหรับ key "$key" ใน environment "$currentEnvironment".'));
  }
}
