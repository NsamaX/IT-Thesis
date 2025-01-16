import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  final Locale locale;
  late final Map<String, dynamic> localizedStrings;
  late final Map<String, String> languageNames;

  AppLocalizations(this.locale);

  Future<bool> load() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/locales/${locale.languageCode}.json');
      localizedStrings = json.decode(jsonString) as Map<String, dynamic>;

      languageNames = {
        'en': 'English',
        'ja': '日本'
      };

      return true;
    } catch (e) {
      throw Exception('Failed to load localization file for ${locale.languageCode}: ${e.toString()}');
    }
  }

  String translate(String key) {
    try {
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
    } catch (e) {
      return key;
    }
  }

  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  static const List<String> supportedLanguages = ['en', 'ja'];

  @override
  bool isSupported(Locale locale) => supportedLanguages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
