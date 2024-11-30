import '../../data/repositories/settings.dart';

class LoadSetting {
  final SettingsRepository repository;

  LoadSetting(this.repository);

  Future<String?> call(String key) async {
    return await repository.loadSetting(key);
  }
}

class SaveSetting {
  final SettingsRepository repository;

  SaveSetting(this.repository);

  Future<void> call(String key, String value) async {
    await repository.saveSetting(key, value);
  }
}
