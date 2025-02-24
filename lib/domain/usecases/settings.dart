import 'package:nfc_project/data/repositories/settings.dart';

/*------------------------------------------------------------------------------
 |  คลาส SaveSettingUseCase
 |
 |  วัตถุประสงค์:
 |      ใช้สำหรับบันทึกค่าการตั้งค่าในแอป
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ SettingsRepository ที่ใช้ในการจัดการค่าการตั้งค่า
 *----------------------------------------------------------------------------*/
class SaveSettingUseCase {
  final SettingsRepository repository;
  
  SaveSettingUseCase(this.repository);

  Future<void> call(String key, dynamic value) async => repository.saveSetting(key, value);
}

/*------------------------------------------------------------------------------
 |  คลาส LoadSettingUseCase
 |
 |  วัตถุประสงค์:
 |      ใช้สำหรับโหลดค่าการตั้งค่าที่ถูกบันทึกไว้
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ SettingsRepository ที่ใช้ในการดึงค่าการตั้งค่า
 *----------------------------------------------------------------------------*/
class LoadSettingUseCase {
  final SettingsRepository repository;

  LoadSettingUseCase(this.repository);

  Future<dynamic> call(String key) async => repository.loadSetting(key);
}
