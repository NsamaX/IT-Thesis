import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// จัดการการแปลภาษาสำหรับแอปพลิเคชัน
class AppLocalizations {
  /// เก็บ locale ปัจจุบัน เช่น `en`, `ja`
  final Locale locale;

  /// สร้างออบเจ็กต์ของ `AppLocalizations` โดยใช้ locale
  AppLocalizations(this.locale);

  /// ดึงออบเจ็กต์ `AppLocalizations` จาก `BuildContext`
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// Delegate สำหรับ `AppLocalizations`
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// เก็บข้อความแปลทั้งหมดในรูปแบบ Map
  late Map<String, dynamic> localizedStrings;

  //----------------------------- โหลดไฟล์แปลภาษา ----------------------------//
  /// โหลดไฟล์ JSON ที่เกี่ยวข้องกับภาษาและตั้งค่า `localizedStrings`
  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/locales/${locale.languageCode}.json');
    localizedStrings = json.decode(jsonString);
    return true;
  }

  //-------------------------------- แปลข้อความ -------------------------------//
  /// แปลข้อความตาม `key` ที่ระบุ
  /// - โดยแยก key ที่เป็นรูปแบบ `key1.key2` เพื่อค้นหาใน Map
  /// - หากไม่พบ key จะคืนค่า key เดิม
  String translate(String key) {
    try {
      List<String> keys = key.split('.');
      dynamic value = localizedStrings;
      for (String k in keys) {
        if (value is Map<String, dynamic> && value.containsKey(k)) {
          value = value[k];
        } else {
          return key;
        }
      }
      return value.toString();
    } catch (e) {
      return key;
    }
  }
}

/// Delegate สำหรับจัดการการโหลดภาษาของแอป
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  /// ตรวจสอบว่า locale ที่ระบุรองรับหรือไม่
  @override
  bool isSupported(Locale locale) => ['en', 'ja'].contains(locale.languageCode);

  /// โหลดไฟล์แปลภาษาสำหรับ locale ที่ระบุ
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  /// ระบุว่า delegate ควรโหลดใหม่หรือไม่
  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
