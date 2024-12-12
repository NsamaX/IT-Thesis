import 'package:nfc_project/data/repositories/settings.dart';

class LoadSetting {
  final SettingsRepository repository;

  LoadSetting(this.repository);

  Future<dynamic> call(String key) async {
    return await repository.loadSetting(key);
  }
}

class SaveSetting {
  final SettingsRepository repository;

  SaveSetting(this.repository);

  Future<void> call(String key, dynamic value) async {
    await repository.saveSetting(key, value);
  }
}
