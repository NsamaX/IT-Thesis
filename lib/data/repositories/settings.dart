import '../datasources/local/settings.dart';

abstract class SettingsRepository {
  /// ดึงค่าการตั้งค่าทั้งหมดจาก Local Data Source
  Future<Map<String, dynamic>> loadSettings();

  /// ดึงค่าการตั้งค่าเฉพาะคีย์
  Future<dynamic> loadSetting(String key);

  /// บันทึกค่าการตั้งค่าทั้งหมดใน Local Data Source
  Future<void> saveSettings(Map<String, dynamic> settings);

  /// บันทึกค่าการตั้งค่าเฉพาะคีย์
  Future<void> saveSetting(String key, dynamic value);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<Map<String, dynamic>> loadSettings() async {
    return await localDataSource.loadSettings();
  }

  @override
  Future<dynamic> loadSetting(String key) async {
    final settings = await loadSettings();
    if (SettingsLocalDataSourceImpl.defaultSettings.containsKey(key)) {
      return settings[key] ?? SettingsLocalDataSourceImpl.defaultSettings[key];
    } else {
      throw Exception('Invalid key: $key');
    }
  }

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await localDataSource.saveSettings(settings);
  }

  @override
  Future<void> saveSetting(String key, dynamic value) async {
    final settings = Map<String, dynamic>.from(await loadSettings());
    settings[key] = value;
    await saveSettings(settings);
  }
}
