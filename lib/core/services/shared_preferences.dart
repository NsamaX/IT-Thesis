import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../exceptions/local_data.dart';

/// บริการสำหรับจัดการ Shared Preferences ในแอปพลิเคชัน
class SharedPreferencesService {
  /// อินสแตนซ์ของ SharedPreferences
  final SharedPreferences _sharedPreferences;

  /// สร้างออบเจ็กต์ SharedPreferencesService ด้วย SharedPreferences ที่ส่งเข้ามา
  SharedPreferencesService(SharedPreferences sharedPreferences) : _sharedPreferences = sharedPreferences;

  //-------------------------------- การดึงข้อมูล -------------------------------//
  /// ดึงค่าที่เป็น String ตาม [key]
  /// - หากไม่พบหรือเกิดข้อผิดพลาด จะโยนข้อยกเว้น [LocalDataException]
  String? getString(String key) {
    try {
      return _sharedPreferences.getString(key);
    } catch (e) {
      throw LocalDataException('ไม่สามารถดึงข้อมูลประเภท String ได้', details: e.toString());
    }
  }

  /// ดึงค่าที่เป็น List<String> ตาม [key]
  List<String>? getStringList(String key) {
    try {
      return _sharedPreferences.getStringList(key);
    } catch (e) {
      throw LocalDataException('ไม่สามารถดึงข้อมูลประเภท List<String> ได้', details: e.toString());
    }
  }

  /// ดึงค่าที่เป็น Map<String, dynamic> ตาม [key]
  /// - แปลงค่าจาก JSON String เป็น Map
  Map<String, dynamic>? getMap(String key) {
    try {
      final jsonString = _sharedPreferences.getString(key);
      return jsonString != null
          ? json.decode(jsonString) as Map<String, dynamic>
          : null;
    } catch (e) {
      throw LocalDataException('ไม่สามารถดึงข้อมูลประเภท Map ได้', details: e.toString());
    }
  }

  //------------------------------- การบันทึกข้อมูล ------------------------------//
  /// บันทึกค่า String โดยใช้ [key] และ [value]
  Future<void> saveString(String key, String value) async {
    try {
      await _sharedPreferences.setString(key, value);
    } catch (e) {
      throw LocalDataException('ไม่สามารถบันทึกข้อมูลประเภท String ได้', details: e.toString());
    }
  }

  /// บันทึกค่า List<String> โดยใช้ [key] และ [value]
  Future<void> saveStringList(String key, List<String> value) async {
    try {
      await _sharedPreferences.setStringList(key, value);
    } catch (e) {
      throw LocalDataException('ไม่สามารถบันทึกข้อมูลประเภท List<String> ได้', details: e.toString());
    }
  }

  /// บันทึกค่า Map<String, dynamic> โดยใช้ [key] และ [map]
  /// - แปลง Map เป็น JSON String ก่อนบันทึก
  Future<void> saveMap(String key, Map<String, dynamic> map) async {
    try {
      final jsonString = json.encode(map);
      await _sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw LocalDataException('ไม่สามารถบันทึกข้อมูลประเภท Map ได้', details: e.toString());
    }
  }

  //-------------------------------- การลบข้อมูล -------------------------------//
  /// ลบค่าตาม [key]
  Future<void> clearKey(String key) async {
    try {
      await _sharedPreferences.remove(key);
    } catch (e) {
      throw LocalDataException('ไม่สามารถลบข้อมูลตาม Key ได้', details: e.toString());
    }
  }

  /// ลบข้อมูลทั้งหมดใน Shared Preferences
  Future<void> clearAll() async {
    try {
      await _sharedPreferences.clear();
    } catch (e) {
      throw LocalDataException('ไม่สามารถลบข้อมูลทั้งหมดใน Shared Preferences ได้', details: e.toString());
    }
  }
}
