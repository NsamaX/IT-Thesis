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
    bool? firstLoad,
    bool? isDarkMode,
  }) => SettingsState(
    locale: locale ?? this.locale,
    isDarkMode: isDarkMode ?? this.isDarkMode,
    firstLoad: firstLoad ?? this.firstLoad,
  );
}

class SettingsCubit extends Cubit<SettingsState> {
  final SaveSettingUseCase saveSettingUsecase;
  final LoadSettingUseCase loadSettingUsecase;

  SettingsCubit({
    required this.saveSettingUsecase,
    required this.loadSettingUsecase,
  }) : super(const SettingsState(
          locale: Locale('en'),
          isDarkMode: true,
          firstLoad: true,
        ));

  Future<void> initialize() async {
    try {
      final localeCode = await loadSettingUsecase('locale');
      final isDarkMode = await loadSettingUsecase('isDarkMode');
      final firstLoad = await loadSettingUsecase('firstLoad');
      emit(state.copyWith(
        locale: Locale(localeCode),
        firstLoad: firstLoad,
        isDarkMode: isDarkMode,
      ));
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> updateLanguage(String languageCode) async {
    await _updateSetting('locale', languageCode, (state) {
      emit(state.copyWith(locale: Locale(languageCode)));
    });
  }

  Future<void> updateTheme(bool isDarkMode) async {
    await _updateSetting('isDarkMode', isDarkMode, (state) {
      emit(state.copyWith(isDarkMode: isDarkMode));
    });
  }

  Future<void> updateFirstLoad(bool firstLoad) async {
    await _updateSetting('firstLoad', firstLoad, (state) {
      emit(state.copyWith(firstLoad: firstLoad));
    });
  }

  Future<void> _updateSetting<T>(
    String key,
    T value,
    void Function(SettingsState) onUpdate,
  ) async {
    try {
      await saveSettingUsecase(key, value);
      onUpdate(state);
    } catch (e) {
      debugPrint('Error updating $key: $e');
    }
  }
}
