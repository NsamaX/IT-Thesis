import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  late final SharedPreferences _sharedPreferences;

  static const String _selectedGameKey = 'selectedGame';

  SharedPreferencesService(this._sharedPreferences);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน saveMap
   |
   |  วัตถุประสงค์:
   |      บันทึก Map<String, dynamic> ลงใน SharedPreferences ในรูปแบบ JSON
   |
   |  พารามิเตอร์:
   |      key (IN) -- คีย์ที่ใช้บันทึกค่าใน SharedPreferences
   |      map (IN) -- Map ที่ต้องการบันทึก
   |
   |  ค่าที่คืนกลับ:
   |      - Future<void> ที่ระบุว่าการบันทึกเสร็จสิ้น
   *--------------------------------------------------------------------------*/
  Future<void> saveMap(String key, Map<String, dynamic> map) async {
    try {
      final String jsonString = json.encode(map);
      await _sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw Exception('Failed to save Map for key "$key": ${e.toString()}');
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน getMap
   |
   |  วัตถุประสงค์:
   |      ดึงค่า Map<String, dynamic> จาก SharedPreferences
   |
   |  พารามิเตอร์:
   |      key (IN) -- คีย์ที่ใช้ดึงค่าจาก SharedPreferences
   |      fallback (IN) -- ค่าที่จะคืนกลับถ้าหาไม่พบ (ค่าเริ่มต้น: null)
   |
   |  ค่าที่คืนกลับ:
   |      - Map<String, dynamic>? ถ้าพบค่า
   |      - ค่า fallback ถ้าไม่พบหรือเกิด error
   *--------------------------------------------------------------------------*/
  Map<String, dynamic>? getMap(String key, {Map<String, dynamic>? fallback}) {
    try {
      final String? jsonString = _sharedPreferences.getString(key);
      return jsonString != null
          ? json.decode(jsonString) as Map<String, dynamic>
          : fallback;
    } catch (e) {
      return fallback;
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน saveString
   |
   |  วัตถุประสงค์:
   |      บันทึกค่าข้อความ (String) ลงใน SharedPreferences
   |
   |  พารามิเตอร์:
   |      key (IN) -- คีย์ที่ใช้บันทึกค่า
   |      value (IN) -- ค่าที่ต้องการบันทึก
   |
   |  ค่าที่คืนกลับ:
   |      - Future<void> ที่ระบุว่าการบันทึกเสร็จสิ้น
   *--------------------------------------------------------------------------*/
  Future<void> saveString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน getString
   |
   |  วัตถุประสงค์:
   |      ดึงค่าข้อความ (String) จาก SharedPreferences
   |
   |  พารามิเตอร์:
   |      key (IN) -- คีย์ที่ใช้ดึงค่า
   |
   |  ค่าที่คืนกลับ:
   |      - String? ถ้าพบค่า
   |      - null ถ้าไม่พบ
   *--------------------------------------------------------------------------*/
  String? getString(String key) => _sharedPreferences.getString(key);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน saveSelectedGame
   |
   |  วัตถุประสงค์:
   |      บันทึกชื่อเกมที่ถูกเลือกไว้ใน SharedPreferences
   |
   |  พารามิเตอร์:
   |      game (IN) -- ชื่อเกมที่ต้องการบันทึก
   |
   |  ค่าที่คืนกลับ:
   |      - Future<void> ที่ระบุว่าการบันทึกเสร็จสิ้น
   *--------------------------------------------------------------------------*/
  Future<void> saveSelectedGame(String game) async {
    await _sharedPreferences.setString(_selectedGameKey, game);
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน getSelectedGame
   |
   |  วัตถุประสงค์:
   |      ดึงค่าชื่อเกมที่ถูกเลือกจาก SharedPreferences
   |
   |  ค่าที่คืนกลับ:
   |      - String? ถ้าพบค่า
   |      - null ถ้าไม่พบ
   *--------------------------------------------------------------------------*/
  String? getSelectedGame() => _sharedPreferences.getString(_selectedGameKey);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน remove
   |
   |  วัตถุประสงค์:
   |      ลบค่าที่เก็บไว้ใน SharedPreferences ตาม key ที่กำหนด
   |
   |  พารามิเตอร์:
   |      key (IN) -- คีย์ของค่าที่ต้องการลบ
   |
   |  ค่าที่คืนกลับ:
   |      - Future<void> ที่ระบุว่าการลบเสร็จสิ้น
   *--------------------------------------------------------------------------*/
  Future<void> remove(String key) async {
    await _sharedPreferences.remove(key);
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน clear
   |
   |  วัตถุประสงค์:
   |      ลบค่าทั้งหมดที่เก็บไว้ใน SharedPreferences
   |
   |  ค่าที่คืนกลับ:
   |      - Future<void> ที่ระบุว่าการลบเสร็จสิ้น
   *--------------------------------------------------------------------------*/
  Future<void> clear() async {
    await _sharedPreferences.clear();
  }
}
