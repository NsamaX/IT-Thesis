import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import '../cubits/settings.dart';
import '../widgets/labels/settings.dart';
import '../widgets/app_bar.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final cubit = context.read<SettingsCubit>();

    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
      body: SettingsLabelWidget(label: [_buildSupportSettings(locale, cubit)]),
    );
  }

  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) {
    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      locale.translate('title.language'): null,
      null: null,
    };
  }

  Map<String, dynamic> _buildSupportSettings(
    AppLocalizations locale,
    SettingsCubit cubit,
  ) {
    final supportedLanguages = locale.languageNames.entries.map((entry) {
      return {
        'code': entry.key,
        'name': entry.value,
      };
    }).toList();
    return {
      'content': supportedLanguages.map((lang) {
        return {
          'onTap': () => _toggleLanguage(cubit, lang['code']!),
          'text': lang['name']!,
          'select': lang['code'] == locale.locale.languageCode,
        };
      }).toList(),
    };
  }

  void _toggleLanguage(SettingsCubit cubit, String languageCode) {
    cubit.updateLanguage(languageCode);
  }
}
