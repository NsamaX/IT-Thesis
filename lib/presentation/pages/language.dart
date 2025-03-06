import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';

import '../cubits/settings.dart';

import '../widgets/shared/app_bar.dart';
import '../widgets/shared/general_label.dart';

class LanguagePage extends StatelessWidget {
  /*---------------------------------- Build ---------------------------------*/
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final cubit = context.read<SettingsCubit>();
    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
      body: GeneralLabelWidget(label: [_buildSupportedLanguages(locale, cubit)]),
    );
  }

  /*--------------------------------- App Bar --------------------------------*/
  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) => {
    Icons.arrow_back_ios_new_rounded: '/back',
    locale.translate('title.language'): null,
    null: null,
  };

  /*--------------------------------- Feature --------------------------------*/
  Map<String, dynamic> _buildSupportedLanguages(AppLocalizations locale, SettingsCubit cubit) {
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
}
