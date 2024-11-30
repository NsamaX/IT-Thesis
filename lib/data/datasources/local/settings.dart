import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<String?> loadSetting(String key);
  Future<void> saveSetting(String key, String value);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveSetting(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> loadSetting(String key) async {
    return sharedPreferences.getString(key);
  }
}
