import 'package:flutter/material.dart';

class AppTheme {
  //Default brightness
  static const Brightness brightness = Brightness.light;

  //Default font
  static const String fontFamily = 'Roboto';
  static const double defaultTextSize = 16.0;
  static const double titleTextSize = 24.0;

  //Default DataTable font
  static const String dataTableFontFamily = 'JetBrainsMono Nerd Font';
  static const double dataTableFontHeaderSize = 12.0;
  static const double dataTableFontRowSize = 11.0;
  static const FontWeight dataTableFontWeight = FontWeight.w300;
  static const FontWeight dataTableFontWeightThin = FontWeight.w200;
  static const FontWeight dataTableFontWeightBold = FontWeight.bold;
  static const FontWeight dataTableFontWeightNormal = FontWeight.normal;

  //Default Icon Size
  static const double iconSizeSmall = 8.0;
  static const double iconSizeMedium = 16.0;
  static const double iconSizeLarge = 24.0;

  // Default colour theme
  static const Color darkBackground = Color(0xff1e1e1e);
  static const Color lightBackground = Color(0xffffffff);
  static const Color greyBackground = Color.fromARGB(255, 76, 75, 75);

  static const Color defaultDarkFontColor = Color(0xffffa500);
  static const Color defaultLightFontColor = Color(0xff000000);

  static const Color defaultDarkBoldFontColor = Color.fromARGB(255, 219, 218, 218);
  static const Color defaultLightBoldFontColor = Color(0xff1e1e1e);

  static const Color defaultDarkIconColor = Color.fromARGB(255, 219, 218, 218);
  static const Color defaultLightIconColor = Color(0xff1e1e1e);

  static const Color defaultDarkTableBorderColour = Color.fromARGB(255, 219, 218, 218);
  static const Color defaultLightTableBorderColour = Color(0xff000000);
}
