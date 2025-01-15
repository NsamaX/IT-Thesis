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
    final settings = Map<String, dynamic>.from(await localDataSource.loadSettings());
    settings[key] = value;
    await localDataSource.saveSettings(settings);
  }

  @override
  Future<dynamic> loadSetting(String key) async {
    final settings = await localDataSource.loadSettings();
    return settings[key] ?? _getDefaultSetting(key);
  }

  dynamic _getDefaultSetting(String key) {
    return SettingsLocalDataSourceImpl.defaultSettings[key] ?? (throw Exception('Invalid key: $key'));
  }
}
