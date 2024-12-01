import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<Map<String, String>> loadAllSettings();
  Future<String?> loadSetting(String key);
  Future<void> saveSetting(String key, String value);
  Future<void> saveAllSettings(Map<String, String> settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _settingsKey = 'settings';

  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveSetting(String key, String value) async {
    final settings = await loadAllSettings();
    settings[key] = value;
    await saveAllSettings(settings);
  }

  @override
  Future<String?> loadSetting(String key) async {
    final settings = await loadAllSettings();
    return settings[key];
  }

  @override
  Future<Map<String, String>> loadAllSettings() async {
    final settingsString = sharedPreferences.getString(_settingsKey);
    if (settingsString != null) {
      return Map<String, String>.from(json.decode(settingsString));
    }
    return {};
  }

  @override
  Future<void> saveAllSettings(Map<String, String> settings) async {
    final settingsString = json.encode(settings);
    await sharedPreferences.setString(_settingsKey, settingsString);
  }
}
