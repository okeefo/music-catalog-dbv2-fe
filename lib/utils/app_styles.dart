import 'package:flutter/material.dart';

class AppTheme {
  //default font
  static const String fontFamily = 'Roboto';
  static const double defaultTextSize = 16.0;
  static const double titleTextSize = 24.0;

  // default colour theme
  static const Color dark = Color(0xff1e1e1e);
  static const Color light = Color(0xffffffff);
  static const Color grey = Color.fromARGB(255, 76, 75, 75); // Black color for light mode sidebar icon
  static const Color darkFontColor = Color(0xffffa500); // Orange color for dark mode text
  static const Color lightFontColor = Color(0xff000000); // Black color for light mode text
  static const Color darkSideBarText = Color.fromARGB(255, 219, 218, 218); // Black color for dark mode sidebar text
  static const Color darkSideBarIconColor = Color.fromARGB(255, 219, 218, 218); // Black color for dark mode sidebar icon
  static const Color lightSideBarText = Color(0xff1e1e1e); // Black color for light mode sidebar text
  static const Color lightSideBarIconColor = Color(0xff1e1e1e); // Black color for light mode sidebar icon
}
