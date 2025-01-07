import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesService(SharedPreferences sharedPreferences) : _sharedPreferences = sharedPreferences;

  String? getString(String key) {
    try {
      return _sharedPreferences.getString(key);
    } catch (e) {
      throw Exception('Unable to retrieve String data ${e.toString()}');
    }
  }

  List<String>? getStringList(String key) {
    try {
      return _sharedPreferences.getStringList(key);
    } catch (e) {
      throw Exception('Unable to retrieve List<String> data ${e.toString()}');
    }
  }

  Map<String, dynamic>? getMap(String key) {
    try {
      final jsonString = _sharedPreferences.getString(key);
      return jsonString != null
          ? json.decode(jsonString) as Map<String, dynamic>
          : null;
    } catch (e) {
      throw Exception('Unable to retrieve Map data ${e.toString()}');
    }
  }

  Future<void> saveString(String key, String value) async {
    try {
      await _sharedPreferences.setString(key, value);
    } catch (e) {
      throw Exception('Unable to save String data ${e.toString()}');
    }
  }

  Future<void> saveStringList(String key, List<String> value) async {
    try {
      await _sharedPreferences.setStringList(key, value);
    } catch (e) {
      throw Exception('Unable to save List<String> data ${e.toString()}');
    }
  }

  Future<void> saveMap(String key, Map<String, dynamic> map) async {
    try {
      final jsonString = json.encode(map);
      await _sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw Exception('Unable to save Map data ${e.toString()}');
    }
  }

  Future<void> clearKey(String key) async {
    try {
      await _sharedPreferences.remove(key);
    } catch (e) {
      throw Exception('Unable to clear data for the given key ${e.toString()}');
    }
  }

  Future<void> clearAll() async {
    try {
      await _sharedPreferences.clear();
    } catch (e) {
      throw Exception('Unable to clear all data in Shared Preferences ${e.toString()}');
    }
  }
}
