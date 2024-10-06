import 'package:flutter/material.dart';
import 'package:front_end/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_styles.dart';

class ThemeProvider with ChangeNotifier {
  Color _darkFontColor = AppTheme.defaultDarkFontColor;
  Color _lightFontColor = AppTheme.defaultLightFontColor;
  Color _darkBoldFontColor = AppTheme.defaultDarkBoldFontColor;
  Color _lightBoldFontColor = AppTheme.defaultLightBoldFontColor;
  Color _darkIconColor = AppTheme.defaultDarkIconColor;
  Color _lightIconColor = AppTheme.defaultLightIconColor;
  Brightness _brightness = AppTheme.brightness;

  ThemeProvider() {
    _loadPreferences();
  }

  Brightness get brightness => _brightness;
  Color get fontColor => _isDarkMode() ? _darkFontColor : _lightFontColor;
  Color get boldFontColor => _isDarkMode() ? _darkBoldFontColor : _lightBoldFontColor;
  Color get iconColor => _isDarkMode() ? _darkIconColor : _lightIconColor;
  Color get backgroundColour => _isDarkMode() ? AppTheme.darkBackground : AppTheme.lightBackground;
  Color get greyBackground => AppTheme.greyBackground;
  Color get darkFontColor => _darkFontColor;
  Color get lightFontColor => _lightFontColor;
  Color get darkBoldFontColor => _darkBoldFontColor;
  Color get lightBoldFontColor => _lightBoldFontColor;
  Color get darkIconColor => _darkIconColor;
  Color get lightIconColor => _lightIconColor;
  bool get isDarkMode => _brightness == Brightness.dark;

  bool _isDarkMode() {
    return _brightness == Brightness.dark;
  }

  void setDarkFontColor(Color color) {
    _darkFontColor = color;
    _savePreferences();
    notifyListeners();
  }

  void setLightFontColor(Color color) {
    _lightFontColor = color;
    _savePreferences();
    notifyListeners();
  }

  void setDarkBoldFontColor(Color color) {
    _darkBoldFontColor = color;
    _savePreferences();
    notifyListeners();
  }

  void setLightBoldFontColor(Color color) {
    _lightBoldFontColor = color;
    _savePreferences();
    notifyListeners();
  }

  void setDarkIconColor(Color color) {
    _darkIconColor = color;
    _savePreferences();
    notifyListeners();
  }

  void setLightIconColor(Color color) {
    _lightIconColor = color;
    _savePreferences();
    notifyListeners();
  }

  void setBrightness(Brightness brightness) {
    _brightness = brightness;
    _savePreferences();
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _darkFontColor = Color(prefs.getInt('darkFontColor') ?? AppTheme.defaultDarkFontColor.value);
    _lightFontColor = Color(prefs.getInt('lightFontColor') ?? AppTheme.defaultLightFontColor.value);
    _darkBoldFontColor = Color(prefs.getInt('darkBoldFontColor') ?? AppTheme.defaultDarkBoldFontColor.value);
    _lightBoldFontColor = Color(prefs.getInt('lightBoldFontColor') ?? AppTheme.defaultLightBoldFontColor.value);
    _darkIconColor = Color(prefs.getInt('darkIconColor') ?? AppTheme.defaultDarkIconColor.value);
    _lightIconColor = Color(prefs.getInt('lightIconColor') ?? AppTheme.defaultLightIconColor.value);
    _brightness = Brightness.values[prefs.getInt('brightness') ?? Brightness.light.index];
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('darkFontColor', _darkFontColor.value);
    prefs.setInt('lightFontColor', _lightFontColor.value);
    prefs.setInt('darkBoldFontColor', _darkBoldFontColor.value);
    prefs.setInt('lightBoldFontColor', _lightBoldFontColor.value);
    prefs.setInt('darkIconColor', _darkIconColor.value);
    prefs.setInt('lightIconColor', _lightIconColor.value);
    prefs.setInt('brightness', _brightness.index);
  }
}
