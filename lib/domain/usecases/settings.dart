import 'package:nfc_project/data/repositories/settings.dart';

class SaveSettingUseCase {
  final SettingsRepository settingsRepository;

  SaveSettingUseCase(this.settingsRepository);

  Future<void> call(String key, dynamic value) async => settingsRepository.saveSetting(key, value);
}

class LoadSettingUseCase {
  final SettingsRepository settingsRepository;

  LoadSettingUseCase(this.settingsRepository);

  Future<dynamic> call(String key) async => settingsRepository.loadSetting(key);
}
