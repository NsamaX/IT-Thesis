import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/domain/usecases/settings.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class SettingsState extends Equatable {
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

  @override
  List<Object> get props => [locale, isDarkMode, firstLoad];
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

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> initialize() async {
    try {
      final localeCode = await loadSettingUsecase('locale') ?? 'en';
      final isDarkMode = await loadSettingUsecase('isDarkMode') ?? true;
      final firstLoad = await loadSettingUsecase('firstLoad') ?? true;

      emit(state.copyWith(
        locale: Locale(localeCode),
        isDarkMode: isDarkMode,
        firstLoad: firstLoad,
      ));
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  Future<void> updateSetting<T>(String key, T value) async {
    try {
      await saveSettingUsecase(key, value);
      emit(_mapUpdatedState(key, value));
    } catch (e) {
      debugPrint('Error updating $key: $e');
    }
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  SettingsState _mapUpdatedState<T>(String key, T value) {
    switch (key) {
      case 'locale':
        return state.copyWith(locale: Locale(value as String));
      case 'isDarkMode':
        return state.copyWith(isDarkMode: value as bool);
      case 'firstLoad':
        return state.copyWith(firstLoad: value as bool);
      default:
        return state;
    }
  }
}
