import 'dart:convert';

import 'package:flutter/services.dart';

class ApiConfig {
  static late String currentEnvironment;
  static late Map<String, String> baseUrls;

  static const String _configPath = 'assets/configs/api.json';

  static Future<void> loadConfig({String environment = 'development'}) async {
    try {
      final String jsonString = await rootBundle.loadString(_configPath);
      final Map<String, dynamic> config = json.decode(jsonString);
      
      final environments = config['environments'] as Map<String, dynamic>?;
      if (environments == null || environments[environment] == null) {
        throw Exception('Environment "$environment" not found in file $_configPath');
      }

      currentEnvironment = environment;
      baseUrls = Map<String, String>.from(environments[environment] as Map);
    } catch (e) {
      throw Exception('Failed to load API settings: ${e.toString()}');
    }
  }

  static String getBaseUrl(String key) => baseUrls[key] ?? (
    throw Exception('Base URL not found for key "$key" in Environment "$currentEnvironment"')
  );
}
