import '../datasources/local/settings.dart';

abstract class SettingsRepository {
  Future<void> saveSetting(String key, dynamic value);
  Future<dynamic> loadSetting(String key);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource datasource;

  SettingsRepositoryImpl(this.datasource);

  @override
  Future<void> saveSetting(String key, dynamic value) async {
    final settings = Map<String, dynamic>.from(await datasource.loadSettings());
    settings[key] = value;
    await datasource.saveSettings(settings);
  }

  @override
  Future<dynamic> loadSetting(String key) async {
    final settings = await datasource.loadSettings();
    return settings[key] ?? _getDefaultSetting(key);
  }

  dynamic _getDefaultSetting(String key) => SettingsLocalDataSourceImpl.defaultSettings[key] ?? (
    throw Exception('Invalid key: $key')
  );
}
