import 'package:flutter/material.dart';

class LocalizationHelper {
  static String getLocalizedText({
    required BuildContext context,
    required String englishText,
    required String arabicText,
  }) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    return currentLocale == 'ar' ? arabicText : englishText;
  }
}