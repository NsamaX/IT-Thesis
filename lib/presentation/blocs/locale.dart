import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/usecases/settings.dart';

class LocaleState {
  final Locale locale;

  const LocaleState({required this.locale});
}

class LocaleCubit extends Cubit<LocaleState> {
  final SaveSetting saveSetting;
  final LoadSetting loadSetting;

  LocaleCubit({
    required this.saveSetting,
    required this.loadSetting,
  }) : super(const LocaleState(locale: Locale('en')));

  Future<void> loadLanguage() async {
    final languageCode = await loadSetting('locale') ?? 'en';
    emit(LocaleState(locale: Locale(languageCode)));
  }

  Future<void> updateLanguage(String languageCode) async {
    await saveSetting('locale', languageCode);
    emit(LocaleState(locale: Locale(languageCode)));
  }
}
