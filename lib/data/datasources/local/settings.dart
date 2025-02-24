import 'dart:collection';
import 'package:nfc_project/core/storage/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน saveSettings
   |
   |  วัตถุประสงค์:
   |      บันทึกค่าการตั้งค่าลงใน SharedPreferences
   |
   |  พารามิเตอร์:
   |      settings (IN) -- Map ของค่าการตั้งค่าที่ต้องการบันทึก
   |
   |  ค่าที่คืนกลับ: ไม่มีค่าคืนกลับ (เป็น Future<void>)
   *--------------------------------------------------------------------------*/
  Future<void> saveSettings(Map<String, dynamic> settings);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน loadSettings
   |
   |  วัตถุประสงค์:
   |      โหลดค่าการตั้งค่าที่บันทึกไว้จาก SharedPreferences
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Future<Map<String, dynamic>> ที่เก็บค่าการตั้งค่า
   |      - ถ้าไม่มีค่าการตั้งค่าที่บันทึกไว้ จะคืนค่า `defaultSettings`
   *--------------------------------------------------------------------------*/
  Future<Map<String, dynamic>> loadSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferencesService _sharedPreferencesService;

  static const String _settingsKey = 'settings';

  static final Map<String, dynamic> defaultSettings = UnmodifiableMapView({
    'locale': 'en',
    'isDarkMode': true,
    'firstLoad': true,
  });

  SettingsLocalDataSourceImpl(this._sharedPreferencesService);

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _sharedPreferencesService.saveMap(_settingsKey, settings);
  }

  @override
  Future<Map<String, dynamic>> loadSettings() async {
    return _sharedPreferencesService.getMap(_settingsKey) ?? defaultSettings;
  }
}
