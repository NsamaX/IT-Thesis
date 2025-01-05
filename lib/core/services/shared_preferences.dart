import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../exceptions/local_data.dart';

abstract class SharedPreferencesServiceInterface {
  String? getString(String key);
  List<String>? getStringList(String key);
  Map<String, dynamic>? getMap(String key);
  Future<void> saveString(String key, String value);
  Future<void> saveStringList(String key, List<String> value);
  Future<void> saveMap(String key, Map<String, dynamic> map);
  Future<void> clearKey(String key);
  Future<void> clearAll();
}

class SharedPreferencesService implements SharedPreferencesServiceInterface {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesService(SharedPreferences sharedPreferences) : _sharedPreferences = sharedPreferences;

  @override
  String? getString(String key) {
    try {
      return _sharedPreferences.getString(key);
    } catch (e) {
      throw LocalDataException('Unable to retrieve String data', details: e.toString());
    }
  }

  @override
  List<String>? getStringList(String key) {
    try {
      return _sharedPreferences.getStringList(key);
    } catch (e) {
      throw LocalDataException('Unable to retrieve List<String> data', details: e.toString());
    }
  }

  @override
  Map<String, dynamic>? getMap(String key) {
    try {
      final jsonString = _sharedPreferences.getString(key);
      return jsonString != null
          ? json.decode(jsonString) as Map<String, dynamic>
          : null;
    } catch (e) {
      throw LocalDataException('Unable to retrieve Map data', details: e.toString());
    }
  }

  @override
  Future<void> saveString(String key, String value) async {
    try {
      await _sharedPreferences.setString(key, value);
    } catch (e) {
      throw LocalDataException('Unable to save String data', details: e.toString());
    }
  }

  @override
  Future<void> saveStringList(String key, List<String> value) async {
    try {
      await _sharedPreferences.setStringList(key, value);
    } catch (e) {
      throw LocalDataException('Unable to save List<String> data', details: e.toString());
    }
  }

  @override
  Future<void> saveMap(String key, Map<String, dynamic> map) async {
    try {
      final jsonString = json.encode(map);
      await _sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw LocalDataException('Unable to save Map data', details: e.toString());
    }
  }

  @override
  Future<void> clearKey(String key) async {
    try {
      await _sharedPreferences.remove(key);
    } catch (e) {
      throw LocalDataException('Unable to clear data for the given key', details: e.toString());
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _sharedPreferences.clear();
    } catch (e) {
      throw LocalDataException('Unable to clear all data in Shared Preferences', details: e.toString());
    }
  }
}
