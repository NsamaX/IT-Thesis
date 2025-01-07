import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesService(this._sharedPreferences);

  String? getString(String key) {
    try {
      return _sharedPreferences.getString(key);
    } catch (e) {
      throw Exception('Unable to retrieve String data: ${e.toString()}');
    }
  }

  List<String>? getStringList(String key) {
    try {
      return _sharedPreferences.getStringList(key);
    } catch (e) {
      throw Exception('Unable to retrieve List<String> data: ${e.toString()}');
    }
  }

  Map<String, dynamic>? getMap(String key) {
    try {
      final String? jsonString = _sharedPreferences.getString(key);
      return jsonString != null ? json.decode(jsonString) as Map<String, dynamic> : null;
    } catch (e) {
      throw Exception('Unable to retrieve Map data: ${e.toString()}');
    }
  }

  Future<void> saveString(String key, String value) async => _handleAsync(
    () => _sharedPreferences.setString(key, value), 'String');

  Future<void> saveStringList(String key, List<String> value) async => _handleAsync(
    () => _sharedPreferences.setStringList(key, value), 'List<String>');

  Future<void> saveMap(String key, Map<String, dynamic> map) async => _handleAsync(
    () => _sharedPreferences.setString(key, json.encode(map)), 'Map');

  Future<void> clearKey(String key) async => _handleAsync(
    () => _sharedPreferences.remove(key), 'clear data for key');

  Future<void> clearAll() async => _handleAsync(
    () => _sharedPreferences.clear(), 'clear all data');

  Future<void> _handleAsync(Future<bool> Function() action, String dataType) async {
    try {
      await action();
    } catch (e) {
      throw Exception('Unable to $dataType: ${e.toString()}');
    }
  }
}
