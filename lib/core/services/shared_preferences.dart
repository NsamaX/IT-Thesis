import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesService(this._sharedPreferences);

  static const String _selectedGameKey = 'selectedGame';

  Future<void> saveMap(String key, Map<String, dynamic> map) async {
    try {
      final String jsonString = json.encode(map);
      await _sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw Exception('Failed to save Map for key "$key": ${e.toString()}');
    }
  }

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

  Future<void> saveSelectedGame(String game) async {
    await _sharedPreferences.setString(_selectedGameKey, game);
  }

  String? getSelectedGame() {
    return _sharedPreferences.getString(_selectedGameKey);
  }
}
