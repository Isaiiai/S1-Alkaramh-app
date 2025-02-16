import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}