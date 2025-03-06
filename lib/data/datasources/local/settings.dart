import 'dart:collection';

import 'package:nfc_project/core/storage/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<void> saveSettings(Map<String, dynamic> settings);
  Future<Map<String, dynamic>> loadSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferencesService _sharedPreferencesService;

  static const String _settingsKey = 'settings';

  static final Map<String, dynamic> defaultSettings = UnmodifiableMapView({
    'locale': 'en',
    'isDarkMode': true,
    'firstLoad': true,
  });

  SettingsLocalDataSourceImpl(this._sharedPreferencesService);

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _sharedPreferencesService.saveMap(_settingsKey, settings);
  }

  @override
  Future<Map<String, dynamic>> loadSettings() async {
    return _sharedPreferencesService.getMap(_settingsKey) ?? defaultSettings;
  }
}
