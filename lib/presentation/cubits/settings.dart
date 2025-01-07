import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/usecases/settings.dart';

class SettingsState {
  final Locale locale;
  final bool firstLoad, isDarkMode;

  const SettingsState({
    required this.locale,
    required this.firstLoad,
    required this.isDarkMode,
  });

  SettingsState copyWith({
    Locale? locale,
    bool? firstLoad, isDarkMode,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      firstLoad: firstLoad ?? this.firstLoad,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SaveSettingUseCase saveSetting;
  final LoadSettingUseCase loadSetting;

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
      final firstLoad = await loadSetting('firstLoad') ?? true;
      final isDarkMode = await loadSetting('isDarkMode') ?? true;

      emit(SettingsState(
        locale: Locale(localeCode),
        firstLoad: firstLoad,
        isDarkMode: isDarkMode,
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
