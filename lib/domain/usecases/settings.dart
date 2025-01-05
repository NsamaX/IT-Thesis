import 'package:nfc_project/data/repositories/settings.dart';

class SaveSettingUseCase {
  final SettingsRepository repository;

  SaveSettingUseCase(this.repository);

  Future<void> call(String key, dynamic value) async {
    await repository.saveSetting(key, value);
  }
}

class LoadSettingUseCase {
  final SettingsRepository repository;

  LoadSettingUseCase(this.repository);

  Future<dynamic> call(String key) async {
    return await repository.loadSetting(key);
  }
}
