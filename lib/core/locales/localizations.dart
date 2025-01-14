import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  final Locale locale;
  late final Map<String, dynamic> localizedStrings;

  AppLocalizations(this.locale);

  Future<bool> load() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/locales/${locale.languageCode}.json');
      localizedStrings = json.decode(jsonString) as Map<String, dynamic>;
      return true;
    } catch (e) {
      throw Exception('Failed to load localization file: ${e.toString()}');
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
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ja'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
