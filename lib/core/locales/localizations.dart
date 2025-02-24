import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
class AppLocalizations {
  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  final Locale locale;
  late final Map<String, dynamic> localizedStrings;

  static late final UnmodifiableListView<String> supportedLanguages;
  static late final UnmodifiableMapView<String, String> languageNames;

  static const String _localesPath = 'assets/locales';

  AppLocalizations(this.locale);

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
  Future<bool> load() async {
    try {
      final String jsonString = await rootBundle.loadString('$_localesPath/${locale.languageCode}.json');
      localizedStrings = json.decode(jsonString);
      return true;
    } catch (e) {
      throw Exception('Failed to load localization file (${locale.languageCode}): $e');
    }
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
  String translate(String key) => key.split('.').fold<dynamic>(localizedStrings, (value, k) {
    if (value is Map<String, dynamic> && value.containsKey(k)) {
      return value[k];
    }
    return key;
  }).toString();

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
  static String getLanguageName(String languageCode) => languageNames[languageCode] ?? languageCode;
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
