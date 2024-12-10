import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_project/core/utils/exceptions.dart';

abstract class SettingsLocalDataSource {
  Future<Map<String, String>> loadSettings();
  Future<void> saveSettings(Map<String, String> settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _settingsKey = 'settings';
  static const Map<String, String> _defaultSettings = {
    'locale': 'en',
    'isDarkMode': 'true',
  };

  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<Map<String, String>> loadSettings() async {
    try {
      final settingsString = sharedPreferences.getString(_settingsKey);
      if (settingsString != null) Map<String, String>.from(json.decode(settingsString));
      return _defaultSettings;
    } catch (e) {
      throw LocalDataException('Failed to load settings', details: e.toString());
    }
  }

  @override
  Future<void> saveSettings(Map<String, String> settings) async {
    try {
      final settingsString = json.encode(settings);
      await sharedPreferences.setString(_settingsKey, settingsString);
    } catch (e) {
      throw LocalDataException('Failed to save settings', details: e.toString());
    }
  }
}
