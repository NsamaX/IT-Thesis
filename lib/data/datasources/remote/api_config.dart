import 'dart:convert';
import 'package:flutter/services.dart';

class ApiConfig {
  static Map<String, String>? baseUrls;

  static Future<void> loadConfig() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/configs/api.json');
      final Map<String, dynamic> config = json.decode(jsonString);
      if (config['baseUrls'] != null && config['baseUrls'] is Map) {
        baseUrls = Map<String, String>.from(config['baseUrls']);
      } else {
        throw Exception('Invalid format for "baseUrls" in api.json');
      }
    } catch (e) {
      throw Exception('Failed to load API config: $e');
    }
  }

  static String getBaseUrl(String game) {
    if (baseUrls == null) {
      throw Exception(
          'API Config not loaded. Please call loadConfig() before using getBaseUrl().');
    }
    return baseUrls?[game] ??
        (throw Exception('Base URL for game "$game" not found.'));
  }
}
