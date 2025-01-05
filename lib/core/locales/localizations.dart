import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Handles localization for the application
class AppLocalizations {
  /// Stores the current locale, e.g., `en`, `ja`
  final Locale locale;

  /// Constructs an `AppLocalizations` object with the provided locale
  AppLocalizations(this.locale);

  /// Retrieves the `AppLocalizations` object from the `BuildContext`
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// Delegate for `AppLocalizations`
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// Holds all localized strings in a Map
  late Map<String, dynamic> localizedStrings;

  //----------------------------- Load Localization File -----------------------------//
  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/locales/${locale.languageCode}.json');
    localizedStrings = json.decode(jsonString);
    return true;
  }

  //-------------------------------- Translate Text --------------------------------//
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

/// Delegate for managing app localization loading
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  /// Checks if the provided locale is supported
  @override
  bool isSupported(Locale locale) => ['en', 'ja'].contains(locale.languageCode);

  /// Loads the localization file for the provided locale
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  /// Indicates whether the delegate should reload
  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
