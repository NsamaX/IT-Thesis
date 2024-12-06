import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nfc_project/core/utils/exceptions.dart';

abstract class SettingsLocalDataSource {
  Future<Map<String, String>> loadAllSettings();
  Future<String?> loadSetting(String key);
  Future<void> saveAllSettings(Map<String, String> settings);
  Future<void> saveSetting(String key, String value);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _settingsKey = 'settings';

  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<Map<String, String>> loadAllSettings() async {
    try {
      final settingsString = sharedPreferences.getString(_settingsKey);
      if (settingsString != null) {
        return Map<String, String>.from(json.decode(settingsString));
      }
      return {};
    } catch (e) {
      throw CacheException('Failed to load all settings: ${e.runtimeType} - ${e.toString()}');
    }
  }

  @override
  Future<String?> loadSetting(String key) async {
    try {
      final settings = await loadAllSettings();
      return settings[key];
    } catch (e) {
      throw CacheException('Failed to load setting [$key]: ${e.runtimeType} - ${e.toString()}');
    }
  }

  @override
  Future<void> saveAllSettings(Map<String, String> settings) async {
    try {
      final settingsString = json.encode(settings);
      await sharedPreferences.setString(_settingsKey, settingsString);
    } catch (e) {
      throw CacheException('Failed to save all settings: ${e.runtimeType} - ${e.toString()}');
    }
  }

  @override
  Future<void> saveSetting(String key, String value) async {
    try {
      final settings = await loadAllSettings();
      settings[key] = value;
      await saveAllSettings(settings);
    } catch (e) {
      throw CacheException('Failed to save setting [$key]: ${e.runtimeType} - ${e.toString()}');
    }
  }
}
