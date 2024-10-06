import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_styles.dart';

class ThemeProvider with ChangeNotifier {
  Color _darkFontColour = AppTheme.defaultDarkFontColor;
  Color _lightFontColour = AppTheme.defaultLightFontColor;
  Color _darkBoldFontColour = AppTheme.defaultDarkBoldFontColor;
  Color _lightBoldFontColour = AppTheme.defaultLightBoldFontColor;
  Color _darkIconColour = AppTheme.defaultDarkIconColor;
  Color _lightIconColour = AppTheme.defaultLightIconColor;
  Brightness _brightness = AppTheme.brightness;

  ThemeProvider() {
    _loadPreferences();
  }

  Brightness get brightness => _brightness;
  Color get fontColour => _isDarkMode() ? _darkFontColour : _lightFontColour;
  Color get boldFontColour => _isDarkMode() ? _darkBoldFontColour : _lightBoldFontColour;
  Color get iconColour => _isDarkMode() ? _darkIconColour : _lightIconColour;
  Color get backgroundColour => _isDarkMode() ? AppTheme.darkBackground : AppTheme.lightBackground;
  Color get greyBackground => AppTheme.greyBackground;
  Color get darkFontColour => _darkFontColour;
  Color get lightFontColour => _lightFontColour;
  Color get darkBoldFontColour => _darkBoldFontColour;
  Color get lightBoldFontColour => _lightBoldFontColour;
  Color get darkIconColour => _darkIconColour;
  Color get lightIconColour => _lightIconColour;
  bool get isDarkMode => _brightness == Brightness.dark;

  bool _isDarkMode() {
    return _brightness == Brightness.dark;
  }

  void setDarkFontColor(Color color) {
    _darkFontColour = color;
    _savePreferences();
    notifyListeners();
  }

  void setLightFontColor(Color color) {
    _lightFontColour = color;
    _savePreferences();
    notifyListeners();
  }

  void setDarkBoldFontColor(Color color) {
    _darkBoldFontColour = color;
    _savePreferences();
    notifyListeners();
  }

  void setLightBoldFontColor(Color color) {
    _lightBoldFontColour = color;
    _savePreferences();
    notifyListeners();
  }

  void setDarkIconColor(Color color) {
    _darkIconColour = color;
    _savePreferences();
    notifyListeners();
  }

  void setLightIconColor(Color color) {
    _lightIconColour = color;
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
    _darkFontColour = Color(prefs.getInt('darkFontColor') ?? AppTheme.defaultDarkFontColor.value);
    _lightFontColour = Color(prefs.getInt('lightFontColor') ?? AppTheme.defaultLightFontColor.value);
    _darkBoldFontColour = Color(prefs.getInt('darkBoldFontColor') ?? AppTheme.defaultDarkBoldFontColor.value);
    _lightBoldFontColour = Color(prefs.getInt('lightBoldFontColor') ?? AppTheme.defaultLightBoldFontColor.value);
    _darkIconColour = Color(prefs.getInt('darkIconColor') ?? AppTheme.defaultDarkIconColor.value);
    _lightIconColour = Color(prefs.getInt('lightIconColor') ?? AppTheme.defaultLightIconColor.value);
    _brightness = Brightness.values[prefs.getInt('brightness') ?? Brightness.light.index];
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('darkFontColor', _darkFontColour.value);
    prefs.setInt('lightFontColor', _lightFontColour.value);
    prefs.setInt('darkBoldFontColor', _darkBoldFontColour.value);
    prefs.setInt('lightBoldFontColor', _lightBoldFontColour.value);
    prefs.setInt('darkIconColor', _darkIconColour.value);
    prefs.setInt('lightIconColor', _lightIconColour.value);
    prefs.setInt('brightness', _brightness.index);
  }
}
