import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_project/core/utils/exceptions.dart';

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

  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<Map<String, dynamic>> loadSettings() async {
    try {
      final settingsString = sharedPreferences.getString(_settingsKey);
      if (settingsString != null) {
        return Map<String, dynamic>.from(json.decode(settingsString));
      }
      return defaultSettings;
    } catch (e) {
      throw LocalDataException('Failed to load settings', details: e.toString());
    }
  }

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    try {
      final settingsString = json.encode(settings);
      await sharedPreferences.setString(_settingsKey, settingsString);
    } catch (e) {
      throw LocalDataException('Failed to save settings', details: e.toString());
    }
  }
}
