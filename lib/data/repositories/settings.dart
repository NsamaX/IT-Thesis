import '../datasources/local/settings.dart';

abstract class SettingsRepository {
  Future<void> saveSetting(String key, dynamic value);
  Future<dynamic> loadSetting(String key);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveSetting(String key, dynamic value) async {
    try {
      final settings = Map<String, dynamic>.from(await localDataSource.loadSettings());
      settings[key] = value;
      await localDataSource.saveSettings(settings);
    } catch (e) {
      throw Exception('Failed to save setting for key "$key": ${e.toString()}');
    }
  }

  @override
  Future<dynamic> loadSetting(String key) async {
    try {
      final settings = await localDataSource.loadSettings();
      return settings[key] ?? _getDefaultSetting(key);
    } catch (e) {
      throw Exception('Failed to load setting for key "$key": ${e.toString()}');
    }
  }

  dynamic _getDefaultSetting(String key) {
    if (SettingsLocalDataSourceImpl.defaultSettings.containsKey(key)) {
      return SettingsLocalDataSourceImpl.defaultSettings[key];
    } else {
      throw Exception('Invalid key: $key');
    }
  }
}
