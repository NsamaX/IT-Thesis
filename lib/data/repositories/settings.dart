import 'dart:collection';
import '../datasources/local/settings.dart';

abstract class SettingsRepository {
  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน saveSetting
   |
   |  วัตถุประสงค์:
   |      บันทึกค่าการตั้งค่าลงใน local storage
   |
   |  พารามิเตอร์:
   |      key (IN) -- คีย์ของค่าการตั้งค่าที่ต้องการบันทึก
   |      value (IN) -- ค่าที่ต้องการบันทึก
   |
   |  ค่าที่คืนกลับ: Future<void>
   *--------------------------------------------------------------------------*/
  Future<void> saveSetting(String key, dynamic value);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน loadSetting
   |
   |  วัตถุประสงค์:
   |      โหลดค่าการตั้งค่าจาก local storage ตาม key ที่กำหนด
   |
   |  พารามิเตอร์:
   |      key (IN) -- คีย์ของค่าการตั้งค่าที่ต้องการโหลด
   |
   |  ค่าที่คืนกลับ: Future<dynamic> (ค่าที่โหลดจาก storage หรือค่าดีฟอลต์)
   *--------------------------------------------------------------------------*/
  Future<dynamic> loadSetting(String key);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource datasource;
  static late final UnmodifiableMapView<String, dynamic> _defaultSettings;

  SettingsRepositoryImpl(this.datasource) {
    _defaultSettings = UnmodifiableMapView(SettingsLocalDataSourceImpl.defaultSettings);
  }

  @override
  Future<void> saveSetting(String key, dynamic value) async {
    final Map<String, dynamic> settings = await datasource.loadSettings();
    if (settings[key] != value) {
      settings[key] = value;
      await datasource.saveSettings(settings);
    }
  }

  @override
  Future<dynamic> loadSetting(String key) async {
    final settings = await datasource.loadSettings();
    return settings.containsKey(key) ? settings[key] : _getDefaultSetting(key);
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _getDefaultSetting
   |
   |  วัตถุประสงค์:
   |      คืนค่าดีฟอลต์ของค่าการตั้งค่า หากไม่พบใน storage
   |
   |  พารามิเตอร์:
   |      key (IN) -- คีย์ของค่าการตั้งค่าที่ต้องการ
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าดีฟอลต์ถ้าพบ
   |      - ถ้าไม่พบ โยน Exception แจ้งว่า key ไม่ถูกต้อง
   *--------------------------------------------------------------------------*/
  dynamic _getDefaultSetting(String key) {
    if (!_defaultSettings.containsKey(key)) {
      throw Exception('Invalid key: $key');
    }
    return _defaultSettings[key];
  }
}
