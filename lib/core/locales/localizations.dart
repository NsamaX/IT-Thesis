import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  late Map<String, dynamic> localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/locales/${locale.languageCode}.json');
    localizedStrings = json.decode(jsonString);
    return true;
  }

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

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ja'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
