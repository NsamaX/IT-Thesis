import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/usecases/settings.dart';

class SettingsState {
  final Locale locale;
  final bool isDarkMode;
  final bool firstLoad;

  const SettingsState({
    required this.locale,
    required this.isDarkMode,
    required this.firstLoad,
  });

  SettingsState copyWith({
    Locale? locale,
    bool? isDarkMode,
    bool? firstLoad,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      firstLoad: firstLoad ?? this.firstLoad,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SaveSetting saveSetting;
  final LoadSetting loadSetting;

  SettingsCubit({
    required this.saveSetting,
    required this.loadSetting,
  }) : super(SettingsState(
          locale: Locale('en'),
          isDarkMode: true,
          firstLoad: true,
        ));

  Future<void> initialize() async {
    try {
      final localeCode = await loadSetting('locale') ?? 'en';
      final isDarkMode = await loadSetting('isDarkMode') ?? true;
      final firstLoad = await loadSetting('firstLoad') ?? true;

      emit(SettingsState(
        locale: Locale(localeCode),
        isDarkMode: isDarkMode,
        firstLoad: firstLoad,
      ));
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> updateLanguage(String languageCode) async {
    await saveSetting('locale', languageCode);
    emit(state.copyWith(locale: Locale(languageCode)));
  }

  Future<void> updateTheme(bool isDarkMode) async {
    await saveSetting('isDarkMode', isDarkMode);
    emit(state.copyWith(isDarkMode: isDarkMode));
  }

  Future<void> updateFirstLoad(bool firstLoad) async {
    await saveSetting('firstLoad', firstLoad);
    emit(state.copyWith(firstLoad: firstLoad));
  }
}
