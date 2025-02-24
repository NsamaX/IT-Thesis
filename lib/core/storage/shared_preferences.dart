import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class SharedPreferencesService {
  late final SharedPreferences _sharedPreferences;

  static const String _selectedGameKey = 'selectedGame';

  SharedPreferencesService(this._sharedPreferences);

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> saveMap(String key, Map<String, dynamic> map) async {
    try {
      final String jsonString = json.encode(map);
      await _sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw Exception('Failed to save Map for key "$key": ${e.toString()}');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Map<String, dynamic>? getMap(String key, {Map<String, dynamic>? fallback}) {
    try {
      final String? jsonString = _sharedPreferences.getString(key);
      return jsonString != null
          ? json.decode(jsonString) as Map<String, dynamic>
          : fallback;
    } catch (e) {
      return fallback;
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> saveString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  String? getString(String key) => _sharedPreferences.getString(key);

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> saveSelectedGame(String game) async {
    await _sharedPreferences.setString(_selectedGameKey, game);
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  String? getSelectedGame() => _sharedPreferences.getString(_selectedGameKey);

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> remove(String key) async {
    await _sharedPreferences.remove(key);
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> clear() async {
    await _sharedPreferences.clear();
  }
}
