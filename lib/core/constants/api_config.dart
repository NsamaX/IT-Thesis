import 'dart:convert';
import 'package:flutter/services.dart';
import '../exceptions/local_data.dart';

class ApiConfig {
  static String? currentEnvironment;
  static Map<String, String>? baseUrls;

  static Future<void> loadConfig({String environment = 'development'}) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/configs/api.json');
      final Map<String, dynamic> config = json.decode(jsonString);
      final environments = config['environments'] as Map<String, dynamic>?;
      if (environments == null || environments[environment] == null) {
        throw LocalDataException('Environment "$environment" not found in api.json file.');
      }
      currentEnvironment = environment;
      baseUrls = Map<String, String>.from(environments[environment] as Map);
    } catch (e) {
      throw LocalDataException('Failed to load API configuration.', details: e.toString());
    }
  }

  static String getBaseUrl(String key) {
    if (baseUrls == null) {
      throw LocalDataException('API configuration has not been loaded. Call loadConfig() before calling getBaseUrl().');
    }
    return baseUrls?[key] ?? (throw LocalDataException('Base URL for key "$key" not found in environment "$currentEnvironment".'));
  }
}
