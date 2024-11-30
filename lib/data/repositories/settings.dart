import '../datasources/local/settings.dart';

abstract class SettingsRepository {
  Future<String?> loadSetting(String key);
  Future<void> saveSetting(String key, String value);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<String?> loadSetting(String key) async {
    return await localDataSource.loadSetting(key);
  }

  @override
  Future<void> saveSetting(String key, String value) async {
    await localDataSource.saveSetting(key, value);
  }
}
