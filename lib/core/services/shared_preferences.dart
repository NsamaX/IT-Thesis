import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../exceptions/local_data.dart';

class SharedPreferencesService {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesService(SharedPreferences sharedPreferences) : _sharedPreferences = sharedPreferences;

  String? getString(String key) {
    try {
      return _sharedPreferences.getString(key);
    } catch (e) {
      throw LocalDataException('Failed to retrieve string', details: e.toString());
    }
  }

  Future<void> saveString(String key, String value) async {
    try {
      await _sharedPreferences.setString(key, value);
    } catch (e) {
      throw LocalDataException('Failed to save string', details: e.toString());
    }
  }

  List<String>? getStringList(String key) {
    try {
      return _sharedPreferences.getStringList(key);
    } catch (e) {
      throw LocalDataException('Failed to retrieve string list', details: e.toString());
    }
  }

  Future<void> saveStringList(String key, List<String> value) async {
    try {
      await _sharedPreferences.setStringList(key, value);
    } catch (e) {
      throw LocalDataException('Failed to save string list', details: e.toString());
    }
  }

  Map<String, dynamic>? getMap(String key) {
    try {
      final jsonString = _sharedPreferences.getString(key);
      return jsonString != null
          ? json.decode(jsonString) as Map<String, dynamic>
          : null;
    } catch (e) {
      throw LocalDataException('Failed to retrieve map', details: e.toString());
    }
  }

  Future<void> saveMap(String key, Map<String, dynamic> map) async {
    try {
      final jsonString = json.encode(map);
      await _sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw LocalDataException('Failed to save map', details: e.toString());
    }
  }

  Future<void> clearKey(String key) async {
    try {
      await _sharedPreferences.remove(key);
    } catch (e) {
      throw LocalDataException('Failed to clear key', details: e.toString());
    }
  }

  Future<void> clearAll() async {
    try {
      await _sharedPreferences.clear();
    } catch (e) {
      throw LocalDataException('Failed to clear all Shared Preferences', details: e.toString());
    }
  }
}
