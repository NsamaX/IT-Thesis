import 'dart:collection';

import '../datasources/local/settings.dart';

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
abstract class SettingsRepository {
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
  Future<void> saveSetting(String key, dynamic value);

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
  Future<dynamic> loadSetting(String key);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource datasource;
  static late final UnmodifiableMapView<String, dynamic> _defaultSettings;

  SettingsRepositoryImpl(this.datasource) {
    _defaultSettings = UnmodifiableMapView(SettingsLocalDataSourceImpl.defaultSettings);
  }

  @override
  Future<void> saveSetting(String key, dynamic value) async {
    final Map<String, dynamic> settings = await datasource.loadSettings();
    if (settings[key] != value) {
      settings[key] = value;
      await datasource.saveSettings(settings);
    }
  }

  @override
  Future<dynamic> loadSetting(String key) async {
    final settings = await datasource.loadSettings();
    return settings.containsKey(key) ? settings[key] : _getDefaultSetting(key);
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
  dynamic _getDefaultSetting(String key) {
    if (!_defaultSettings.containsKey(key)) {
      throw Exception('Invalid key: $key');
    }
    return _defaultSettings[key];
  }
}
