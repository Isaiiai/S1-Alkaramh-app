part of 'language_bloc.dart';

@immutable
sealed class LanguageEvent {}

class ChangeLanguageEvent extends LanguageEvent {
  final String languageCode;
  ChangeLanguageEvent(this.languageCode);
}