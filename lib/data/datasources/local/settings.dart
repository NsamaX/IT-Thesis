import 'package:nfc_project/core/services/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<void> saveSettings(Map<String, dynamic> settings);
  Future<Map<String, dynamic>> loadSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferencesService _sharedPreferencesService;

  static const String _settingsKey = 'settings';

  static const Map<String, dynamic> defaultSettings = {
    'locale': 'en',
    'isDarkMode': true,
    'firstLoad': true,
  };

  SettingsLocalDataSourceImpl(this._sharedPreferencesService);

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _sharedPreferencesService.saveMap(_settingsKey, settings);
  }

  @override
  Future<Map<String, dynamic>> loadSettings() async {
    final settings = _sharedPreferencesService.getMap(_settingsKey);
    return settings ?? defaultSettings;
  }
}
