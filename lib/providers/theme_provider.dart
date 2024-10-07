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
  Color _lightTableBorderColour = AppTheme.defaultLightTableBorderColour;
  Color _darkTableBorderColour = AppTheme.defaultDarkTableBorderColour;
  Brightness _brightness = AppTheme.brightness;

  ThemeProvider() {
    _loadPreferences();
  }

  Brightness get brightness => _brightness;
  Color get fontColour => _isDarkMode() ? _darkFontColour : _lightFontColour;
  Color get boldFontColour => _isDarkMode() ? _darkBoldFontColour : _lightBoldFontColour;
  Color get iconColour => _isDarkMode() ? _darkIconColour : _lightIconColour;
  Color get backgroundColour => _isDarkMode() ? AppTheme.darkBackground : AppTheme.lightBackground;
  Color get tableBorderColour => _isDarkMode() ? _darkTableBorderColour : _lightTableBorderColour;

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

  void setFontColour(Color color) {
    _isDarkMode() ? _darkFontColour = color : _lightFontColour = color;
    _savePreferences();
    notifyListeners();
  }

  void setBoldFontColor(Color color) {
    _isDarkMode() ? _darkBoldFontColour = color : _lightBoldFontColour = color;
    _savePreferences();
    notifyListeners();
  }

  void setIconColour(Color color) {
    _isDarkMode() ? _darkIconColour = color : _lightIconColour = color;
    _savePreferences();
    notifyListeners();
  }

  void setBrightness(Brightness brightness) {
    _brightness = brightness;
    _savePreferences();
    notifyListeners();
  }

  void setTableBorderColour(Color color) {
    _isDarkMode() ? _darkTableBorderColour = color : _lightTableBorderColour = color;
    _savePreferences();
    notifyListeners();
  }

  void resetDarkColors() {
    _darkFontColour = AppTheme.defaultDarkFontColor;
    _darkBoldFontColour = AppTheme.defaultDarkBoldFontColor;
    _darkIconColour = AppTheme.defaultDarkIconColor;
    _darkTableBorderColour = AppTheme.defaultDarkTableBorderColour;
    _savePreferences();
    notifyListeners();
  }

  void resetLightColors() {
    _lightFontColour = AppTheme.defaultLightFontColor;
    _lightBoldFontColour = AppTheme.defaultLightBoldFontColor;
    _lightIconColour = AppTheme.defaultLightIconColor;
    _lightTableBorderColour = AppTheme.defaultLightTableBorderColour;
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
    _lightTableBorderColour = Color(prefs.getInt('lightTableBorderColour') ?? AppTheme.defaultLightTableBorderColour.value);
    _darkTableBorderColour = Color(prefs.getInt('darkTableBorderColour') ?? AppTheme.defaultDarkTableBorderColour.value);
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
    prefs.setInt('lightTableBorderColour', _lightTableBorderColour.value);
    prefs.setInt('darkTableBorderColour', _darkTableBorderColour.value);
  }
}
