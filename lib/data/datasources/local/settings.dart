import 'package:nfc_project/core/services/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<Map<String, dynamic>> loadSettings();
  Future<void> saveSettings(Map<String, dynamic> settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _settingsKey = 'settings';
  static const Map<String, dynamic> defaultSettings = {
    'locale': 'en',
    'isDarkMode': true,
    'firstLoad': true,
  };

  final SharedPreferencesService _sharedPreferencesService;

  SettingsLocalDataSourceImpl(this._sharedPreferencesService);

  @override
  Future<Map<String, dynamic>> loadSettings() async {
    final settings = _sharedPreferencesService.getMap(_settingsKey);
    return settings ?? defaultSettings;
  }

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _sharedPreferencesService.saveMap(_settingsKey, settings);
  }
}
