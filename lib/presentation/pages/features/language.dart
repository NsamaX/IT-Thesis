import 'package:flutter/material.dart';

import 'package:nfc_project/core/locales/localizations.dart';

import '../../cubits/settings.dart';

Map<dynamic, dynamic> buildAppBarMenu(AppLocalizations locale) => {
  Icons.arrow_back_ios_new_rounded: '/back',
  locale.translate('title.language'): null,
  null: null,
};

Map<String, dynamic> buildSupportedLanguages(AppLocalizations locale, SettingsCubit cubit) {
  final supportedLanguages = AppLocalizations.languageNames.entries.map((entry) => {
    'code': entry.key,
    'name': entry.value,
  }).toList();

  return {
    'content': supportedLanguages.map((lang) => {
      'onTap': () => cubit.updateSetting('locale', lang['code']!),
      'text': lang['name']!,
      'select': lang['code'] == locale.locale.languageCode,
    }).toList(),
  };
}
