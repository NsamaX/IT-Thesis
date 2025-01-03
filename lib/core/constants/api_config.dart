import 'dart:convert';
import 'package:flutter/services.dart';
import '../exceptions/local_data.dart';

/// จัดการการตั้งค่า API โดยโหลด URL ของแต่ละ environment จากไฟล์ JSON
class ApiConfig {
  /// ระบุ environment ที่ใช้งานอยู่ (development หรือ production)
  static String? currentEnvironment;
  
  /// เก็บ URL หลัก (base URLs) ของ environment ปัจจุบัน
  static Map<String, String>? baseUrls;

  //------------------------------- โหลดการตั้งค่า ------------------------------//
  /// โหลดการตั้งค่า API สำหรับ environment ที่ระบุ
  /// - อ่านไฟล์ `api.json` จาก assets
  /// - ดึงข้อมูลและตั้งค่า base URLs สำหรับ environment ที่ระบุ
  /// - หาก environment ไม่พบในไฟล์ หรือไฟล์ไม่สามารถอ่านได้ จะเกิด [LocalDataException]
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

  //------------------------------- ดึง URL หลัก -------------------------------//
  /// ดึง URL หลัก (base URL) สำหรับ [key] ใน environment ปัจจุบัน
  /// - หากยังไม่ได้โหลดการตั้งค่า หรือไม่พบ key ที่ระบุ จะเกิด [LocalDataException]
  static String getBaseUrl(String key) {
    if (baseUrls == null) {
      throw LocalDataException('ยังไม่ได้โหลดการตั้งค่า API กรุณาเรียกใช้ loadConfig() ก่อนเรียก getBaseUrl().');
    }
    return baseUrls?[key] ?? (throw LocalDataException('ไม่พบ Base URL สำหรับ key "$key" ใน environment "$currentEnvironment".'));
  }
}
