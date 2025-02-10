import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  final Locale locale;
  late Map<String, dynamic> localizedStrings;
  static late List<String> supportedLanguages;
  static late Map<String, String> languageNames;

  AppLocalizations(this.locale);

  Future<bool> load() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/locales/${locale.languageCode}.json');
      localizedStrings = json.decode(jsonString);
      languageNames[locale.languageCode] = localizedStrings['language_name'] ?? locale.languageCode;
      return true;
    } catch (e) {
      throw Exception('Failed to load localization file for ${locale.languageCode}: $e');
    }
  }

  String translate(String key) {
    final List<String> keys = key.split('.');
    dynamic value = localizedStrings;
    for (final String k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k];
      } else {
        return key;
      }
    }
    return value.toString();
  }

  static Future<void> loadSupportedLanguages() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      supportedLanguages = manifestMap.keys
          .where((String key) => key.startsWith('assets/locales/') && key.endsWith('.json'))
          .map((String key) => key.split('/').last.split('.').first)
          .toList();
      languageNames = {};
      for (String lang in supportedLanguages) {
        final String jsonString = await rootBundle.loadString('assets/locales/$lang.json');
        final Map<String, dynamic> langData = json.decode(jsonString);
        languageNames[lang] = langData['language_name'] ?? lang;
      }
    } catch (e) {
      throw Exception('Failed to load supported languages: $e');
    }
  }

  static String getLanguageName(String languageCode) => languageNames[languageCode] ?? languageCode;
}

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
