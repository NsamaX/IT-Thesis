import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleState {
  final Locale locale;

  LocaleState(this.locale);
}

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState(const Locale('en', 'US')));

  void changeLocale(String languageCode) {
    emit(LocaleState(Locale(languageCode)));
  }
}
