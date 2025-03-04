import 'package:flutter/material.dart';

  class MyTextTheme {
    static const String fontFamily = 'Nunito';

    static TextStyle headline(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double fontSize = screenWidth * 0.04; // Adjust the multiplier as needed
      return TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: fontFamily,
      );
    }

    static TextStyle subheading(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double fontSize = screenWidth * 0.04; // Adjust the multiplier as needed
      return TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        fontFamily: fontFamily,
      );
    }

    static TextStyle body(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double fontSize = screenWidth * 0.04; // Adjust the multiplier as needed
      return TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        fontFamily: fontFamily,
      );
    }

    static TextStyle normal(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double fontSize = screenWidth * 0.035; // Adjust the multiplier as needed
      return TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        fontFamily: fontFamily,
      );
    }
  }