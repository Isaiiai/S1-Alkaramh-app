import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  static const String LANGUAGE_KEY = 'language_code';

  LanguageBloc() : super(const LanguageInitial()) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(LANGUAGE_KEY);
    if (savedLanguage != null) {
      add(ChangeLanguageEvent(savedLanguage));
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<LanguageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_KEY, event.languageCode);
    emit(LanguageChanged(Locale(event.languageCode)));
  }
}