part of 'language_bloc.dart';

@immutable
abstract class LanguageState {
  final Locale locale;
  const LanguageState(this.locale);
}

class LanguageInitial extends LanguageState {
  const LanguageInitial() : super(const Locale('en', 'US'));
}

class LanguageChanged extends LanguageState {
  const LanguageChanged(Locale locale) : super(locale);
}