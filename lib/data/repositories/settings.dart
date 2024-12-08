import '../datasources/local/settings.dart';

abstract class SettingsRepository {
  Future<Map<String, String>> loadSettings();
  Future<String?> loadSetting(String key);
  Future<void> saveSettings(Map<String, String> settings);
  Future<void> saveSetting(String key, String value);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<Map<String, String>> loadSettings() async {
    return await localDataSource.loadSettings();
  }

  @override
  Future<String?> loadSetting(String key) async {
    final settings = await loadSettings();
    return settings[key];
  }

  @override
  Future<void> saveSettings(Map<String, String> settings) async {
    await localDataSource.saveSettings(settings);
  }

  @override
  Future<void> saveSetting(String key, String value) async {
    final settings = await loadSettings();
    settings[key] = value;
    await saveSettings(settings);
  }
}
