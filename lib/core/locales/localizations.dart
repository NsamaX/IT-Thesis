import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  final Locale locale;
  late final Map<String, dynamic> localizedStrings;

  static late final UnmodifiableListView<String> supportedLanguages;
  static late final UnmodifiableMapView<String, String> languageNames;

  static const String _localesPath = 'assets/locales';

  AppLocalizations(this.locale);

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน load
   |
   |  วัตถุประสงค์:
   |      โหลดไฟล์ JSON สำหรับภาษาที่เลือก และเก็บข้อมูลลงใน `localizedStrings`
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Future<bool> ที่ระบุว่าโหลดสำเร็จหรือไม่
   *--------------------------------------------------------------------------*/
  Future<bool> load() async {
    try {
      final String jsonString = await rootBundle.loadString('$_localesPath/${locale.languageCode}.json');
      localizedStrings = json.decode(jsonString);
      return true;
    } catch (e) {
      throw Exception('Failed to load localization file (${locale.languageCode}): $e');
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน translate
   |
   |  วัตถุประสงค์:
   |      คืนค่าข้อความที่แปลแล้วตาม key ที่กำหนด
   |
   |  พารามิเตอร์:
   |      key (IN) -- คีย์ของข้อความที่ต้องการแปล เช่น "home.title"
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าข้อความที่แปลแล้วเป็น String
   |      - ถ้าไม่พบ key ที่ต้องการ จะแสดง key เดิม
   *--------------------------------------------------------------------------*/
  String translate(String key) => key.split('.').fold<dynamic>(localizedStrings, (value, k) {
    if (value is Map<String, dynamic> && value.containsKey(k)) {
      return value[k];
    }
    return key;
  }).toString();

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน loadSupportedLanguages
   |
   |  วัตถุประสงค์:
   |      โหลดรายการภาษาที่รองรับจากไฟล์ `AssetManifest.json`
   |
   |  ค่าที่คืนกลับ:
   |      - ไม่มีค่าคืนกลับ แต่จะกำหนดค่าตัวแปร `supportedLanguages` และ `languageNames`
   *--------------------------------------------------------------------------*/
  static Future<void> loadSupportedLanguages() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final List<String> languages = manifestMap.keys
          .where((String key) => key.startsWith('$_localesPath/') && key.endsWith('.json'))
          .map((String key) => key.split('/').last.split('.').first)
          .toList();

      final Map<String, String> langMap = {};
      await Future.wait(languages.map((lang) async {
        try {
          final String jsonString = await rootBundle.loadString('$_localesPath/$lang.json');
          final Map<String, dynamic> langData = json.decode(jsonString);
          langMap[lang] = langData['language_name'] ?? lang;
        } catch (_) {
          langMap[lang] = lang;
        }
      }));

      supportedLanguages = UnmodifiableListView(languages);
      languageNames = UnmodifiableMapView(langMap);
    } catch (e) {
      throw Exception('Failed to load supported languages: $e');
    }
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน getLanguageName
   |
   |  วัตถุประสงค์:
   |      คืนค่าชื่อของภาษาตามรหัสภาษา
   |
   |  พารามิเตอร์:
   |      languageCode (IN) -- รหัสภาษาที่ต้องการแปลงเป็นชื่อภาษา
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าชื่อของภาษาเป็น String ถ้าพบ
   |      - ถ้าไม่พบ จะคืนค่าเป็นรหัสภาษานั้น ๆ
   *--------------------------------------------------------------------------*/
  static String getLanguageName(String languageCode) => languageNames[languageCode] ?? languageCode;
}

/*------------------------------------------------------------------------------
 |  Delegate สำหรับ Localizations
 |
 |  วัตถุประสงค์:
 |      ใช้ในการจัดการโหลด Localizations ตาม Locale ที่กำหนด
 *----------------------------------------------------------------------------*/
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLanguages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
