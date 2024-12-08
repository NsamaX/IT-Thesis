import 'dart:convert';
import 'package:flutter/services.dart';

class ApiConfig {
  static Map<String, String>? baseUrls;
  static String? currentEnvironment;

  static Future<void> loadConfig({String environment = 'development'}) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/configs/api.json');
      final Map<String, dynamic> config = json.decode(jsonString);
      final environments = config['environments'] as Map<String, dynamic>?;
      if (environments == null || environments[environment] == null) {
        throw Exception('Environment "$environment" not found in api.json');
      }
      currentEnvironment = environment;
      baseUrls = Map<String, String>.from(environments[environment] as Map);
    } catch (e) {
      throw Exception('Failed to load API config: $e');
    }
  }

  static String getBaseUrl(String key) {
    if (baseUrls == null) {
      throw Exception('API Config not loaded. Please call loadConfig() before using getBaseUrl().');
    }
    return baseUrls?[key] ?? (throw Exception('Base URL for key "$key" not found in environment "$currentEnvironment".'));
  }
}
