import 'dart:convert';
import 'package:flutter/services.dart';

class ApiConfig {
  static Map<String, String>? baseUrls;

  static Future<void> loadConfig() async {
    final String jsonString =
        await rootBundle.loadString('assets/configs/api_config.json');
    final Map<String, dynamic> config = json.decode(jsonString);
    baseUrls = Map<String, String>.from(config['baseUrls']);
  }

  static String getBaseUrl(String game) {
    return baseUrls?[game] ?? '';
  }
}
