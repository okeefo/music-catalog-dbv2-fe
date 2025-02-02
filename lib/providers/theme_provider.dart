import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_styles.dart';

class ThemeProvider with ChangeNotifier {
  late final ThemeColourItem _fontColour;
  late final ThemeColourItem _boldFontColour;
  late final ThemeColourItem _iconColour;
  late final ThemeColourItem _tableBorderColour;
  late final ThemeColourItem _backgroundColour;
  late final ThemeColourItem _headerFontColour;
  late final ThemeColourItem _headerBackgroundColour;
  late final ThemeColourItem _tableFontColour;
  late final ThemeColourItem _tableBackgroundColour;
  late final ThemeColourItem _tableAltFontColour;
  late final ThemeColourItem _tableAltBackgroundColour;
  late final ThemeColourItem _tableSelectFontColour;
  late final ThemeColourItem _tableSelectBackgroundColour;
  late final ThemeColourItem _toggleSwitchBackgroundColour;
  late final ThemeColourItem _toggleSwitchKnobColour;
  late final ThemeColourItem _waveformColour;
  late final ThemeColourItem _waveformProgressColour;
  late final ThemeColourItem _waveformProgressBarColour;

  late List<ThemeColourItem> colourItems;

  Brightness _brightness = AppTheme.brightness;
  double _windowWidth = 800.0;
  double _windowHeight = 600.0;
  String _dataTableFont = AppTheme.dataTableFontFamily;

  ThemeProvider._internal() {
    colourItems = <ThemeColourItem>[];
    _fontColour = ThemeColourItem(
        key: 'font',
        defaultDark: AppTheme.fontColourDark,
        defaultLight: AppTheme.fontColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_fontColour);

    _boldFontColour = ThemeColourItem(
        key: 'boldFont',
        defaultDark: AppTheme.boldFontColourDark,
        defaultLight: AppTheme.boldFontColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_boldFontColour);

    _iconColour = ThemeColourItem(
        key: 'icon',
        defaultDark: AppTheme.iconColorDark,
        defaultLight: AppTheme.iconColorLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_iconColour);

    _tableBorderColour = ThemeColourItem(
        key: 'tableBorder',
        defaultDark: AppTheme.tableBorderColourDark,
        defaultLight: AppTheme.tableBorderColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_tableBorderColour);

    _backgroundColour = ThemeColourItem(
        key: 'background',
        defaultDark: AppTheme.darkBackground,
        defaultLight: AppTheme.lightBackground,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_backgroundColour);

    _headerFontColour = ThemeColourItem(
        key: 'headerFont',
        defaultDark: AppTheme.tableHeaderFontColourDark,
        defaultLight: AppTheme.tableHeaderFontColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_headerFontColour);

    _headerBackgroundColour = ThemeColourItem(
        key: 'headerFontBackground',
        defaultDark: AppTheme.tableHeaderBackgroundColourDark,
        defaultLight: AppTheme.tableHeaderBackgroundColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_headerBackgroundColour);

    _tableFontColour = ThemeColourItem(
        key: 'rowFont',
        defaultDark: AppTheme.tableFontColourDark,
        defaultLight: AppTheme.tableFontColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_tableFontColour);

    _tableBackgroundColour = ThemeColourItem(
        key: 'rowFontBackground',
        defaultDark: AppTheme.tableBackgroundColourDark,
        defaultLight: AppTheme.tableBackgroundColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_tableBackgroundColour);

    _tableAltFontColour = ThemeColourItem(
        key: 'rowAltFont',
        defaultDark: AppTheme.tableFontAltColourDark,
        defaultLight: AppTheme.tableFontAltColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_tableAltFontColour);

    _tableAltBackgroundColour = ThemeColourItem(
        key: 'rowAltFontBackground',
        defaultDark: AppTheme.tableBackgroundAltColourDark,
        defaultLight: AppTheme.tableBackgroundAltColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_tableAltBackgroundColour);

    _tableSelectFontColour = ThemeColourItem(
        key: 'rowSelectFont',
        defaultDark: AppTheme.tableFontSelectColourDark,
        defaultLight: AppTheme.tableFontSelectColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_tableSelectFontColour);

    _tableSelectBackgroundColour = ThemeColourItem(
        key: 'rowSelectFontBackground',
        defaultDark: AppTheme.tableBackgroundSelectColourDark,
        defaultLight: AppTheme.tableBackgroundSelectColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_tableSelectBackgroundColour);

    _toggleSwitchBackgroundColour = ThemeColourItem(
        key: 'toggleSwitch',
        defaultDark: AppTheme.toggleSwitchBackgroundDark,
        defaultLight: AppTheme.toggleSwitchBackgroundLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_toggleSwitchBackgroundColour);

    _toggleSwitchKnobColour = ThemeColourItem(
        key: 'toggleSwitch', defaultDark: AppTheme.black, defaultLight: AppTheme.black, isDarkMode: () => _isDarkMode(), onChanged: () => _onColorChanged());
    colourItems.add(_toggleSwitchBackgroundColour);

    _waveformColour = ThemeColourItem(
        key: 'toggleSwitch',
        defaultDark: AppTheme.waveformColourDark,
        defaultLight: AppTheme.waveformColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_toggleSwitchBackgroundColour);

    _waveformProgressColour = ThemeColourItem(
        key: 'toggleSwitch',
        defaultDark: AppTheme.waveformProgressColourDark,
        defaultLight: AppTheme.waveformProgressColourLight,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_toggleSwitchBackgroundColour);

    _waveformProgressBarColour = ThemeColourItem(
        key: 'toggleSwitch',
        defaultDark: AppTheme.white,
        defaultLight: AppTheme.black,
        isDarkMode: () => _isDarkMode(),
        onChanged: () => _onColorChanged());
    colourItems.add(_toggleSwitchBackgroundColour);
  }

  // Factory constructor
  static Future<ThemeProvider> create() async {
    final provider = ThemeProvider._internal();
    await provider._loadPreferences();
    return provider;
  }

  Brightness get brightness => _brightness;

  // General Fonts
  Color get fontColour => _fontColour.getColour();
  void setFontColour(Color color) {
    _fontColour.setColor(color);
  }

  Color get boldFontColour => _boldFontColour.getColour();
  void setBoldFontColor(Color color) {
    _boldFontColour.setColor(color);
  }

  Color get iconColour => _iconColour.getColour();
  void setIconColour(Color color) {
    _iconColour.setColor(color);
  }

  Color get backgroundColour => _backgroundColour.getColour();
  void setBackgroundColour(Color color) {
    _backgroundColour.setColor(color);
  }

  Color get headerFontColour => _headerFontColour.getColour();
  void setHeaderFontColour(Color color) {
    _headerFontColour.setColor(color);
  }

  Color get headerBackgroundColour => _headerBackgroundColour.getColour();
  void setHeaderFontBackgroundColour(Color color) {
    _headerBackgroundColour.setColor(color);
  }

  Color get tableFontColour => _tableFontColour.getColour();
  void setTableFontColour(Color color) {
    _tableFontColour.setColor(color);
  }

  Color get tableBackgroundColour => _tableBackgroundColour.getColour();
  void setTableBackgroundColour(Color color) {
    _tableBackgroundColour.setColor(color);
  }

  Color get tableAltFontColour => _tableAltFontColour.getColour();
  void setTableAltFontColour(Color color) {
    _tableAltFontColour.setColor(color);
  }

  Color get tableAltBackgroundColour => _tableAltBackgroundColour.getColour();
  void setTableAltBackgroundColour(Color color) {
    _tableAltBackgroundColour.setColor(color);
  }

  Color get tableSelectFontColour => _tableSelectFontColour.getColour();
  void setTableSelectFontColour(Color color) {
    _tableSelectFontColour.setColor(color);
  }

  Color get tableSelectBackgroundColour => _tableSelectBackgroundColour.getColour();
  void setTableSelectBackgroundColour(Color color) {
    _tableSelectBackgroundColour.setColor(color);
  }

  Color get toggleSwitchBackgroundColor => _toggleSwitchBackgroundColour.getColour();
  void setToggleBackgroundColour(Color color) {
    _toggleSwitchBackgroundColour.setColor(color);
  }

  Color get toggleSwitchKnobColor => _toggleSwitchKnobColour.getColour();
  void setToggleKnobColour(Color color) {
    _toggleSwitchKnobColour.setColor(color);
  }

  // Data Table
  Color get tableBorderColour => _tableBorderColour.getColour();
  void setTableBorderColour(Color color) {
    _tableBorderColour.setColor(color);
  }

  String get dataTableFontFamily => _dataTableFont;
  void setDataTableFontFamily(String font) {
    _dataTableFont = font;
    _savePreferences();
    notifyListeners();
  }

  Color get waveformColour => _waveformColour.getColour();
  void setWaveformColour(Color color) {
    _waveformColour.setColor(color);
  }

  Color get waveformProgressColour => _waveformProgressColour.getColour();
  void setWaveformProgressColour(Color color) {
    _waveformProgressColour.setColor(color);
  }

  Color get waveformProgressBarColour => _waveformProgressBarColour.getColour();
  void setWaveformProgressBarColour(Color color) {
    _waveformProgressBarColour.setColor(color);
  }

  double get fontSizeDataTableHeader => AppTheme.dataTableFontHeaderSize;
  double get fontSizeDataTableRow => AppTheme.dataTableFontRowSize;
  FontWeight get dataTableFontWeight => AppTheme.dataTableFontWeight;
  FontWeight get dataTableFontWeightThin => AppTheme.dataTableFontWeightThin;
  FontWeight get dataTableFontWeightBold => AppTheme.dataTableFontWeightBold;
  FontWeight get dataTableFontWeightNormal => AppTheme.dataTableFontWeightNormal;
  Color get transparent => Colors.transparent;

  // Text Styles
  TextStyle get styleTableRow => TextStyle(
        fontWeight: dataTableFontWeightNormal,
        fontFamily: dataTableFontFamily,
        fontSize: fontSizeDataTableRow,
        color: tableFontColour,
      );

  TextStyle get styleTableAltRow => TextStyle(
        fontWeight: dataTableFontWeightNormal,
        fontFamily: dataTableFontFamily,
        fontSize: fontSizeDataTableRow,
        color: tableAltFontColour,
      );

  TextStyle get styleTableSelectRow => TextStyle(
        fontWeight: dataTableFontWeightNormal,
        fontFamily: dataTableFontFamily,
        fontSize: fontSizeDataTableRow,
        color: tableSelectFontColour,
      );

  TextStyle get styleTableHeader => TextStyle(
        fontWeight: dataTableFontWeightBold,
        fontFamily: dataTableFontFamily,
        fontSize: fontSizeDataTableHeader,
        color: headerFontColour,
        backgroundColor: transparent,
      );

  double get fontSizeReg => AppTheme.fontSizeReg;
  double get fontSizeTitle => AppTheme.fontSizeTitle;
  double get fontSizeSmall => AppTheme.fontSizeSmall;
  double get fontSizeLarge => AppTheme.iconSizeLarge;
  FontWeight get fontWeightNorm => AppTheme.fontWeightNorm;
  FontWeight get fontWeightBold => AppTheme.fontWeightBold;
  FontWeight get fontWeightThin => AppTheme.fontWeightThin;

//General Settings.
  Color get greyBackground => AppTheme.greyBackground;

  bool get isDarkMode => _brightness == Brightness.dark;

  double get iconSize => AppTheme.iconSizeSmall;
  double get iconSizeMedium => AppTheme.iconSizeMedium;
  double get iconSizeLarge => AppTheme.iconSizeLarge;

  double get windowWidth => _windowWidth;
  double get windowHeight => _windowHeight;

  Color get selectedRowColor => Colors.grey;

  bool _isDarkMode() {
    return _brightness == Brightness.dark;
  }

  void _onColorChanged() {
    _savePreferences();
    notifyListeners();
  }

  void setBrightness(Brightness brightness) {
    _brightness = brightness;
    _savePreferences();
    notifyListeners();
  }

  void setWindowSize(double width, double height) {
    _windowWidth = width;
    _windowHeight = height;
    _savePreferences();
    notifyListeners();
  }

  void resetDarkColours() {
    for (var item in colourItems) {
      item._resetDarkColor();
    }
    _savePreferences();
    notifyListeners();
  }

  void resetLightColours() {
    for (var item in colourItems) {
      item._resetLightColor();
    }
    _savePreferences();
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    _brightness = Brightness.values[prefs.getInt('brightness') ?? Brightness.light.index];
    _windowWidth = prefs.getDouble('windowWidth') ?? 800.0;
    _windowHeight = prefs.getDouble('windowHeight') ?? 600.0;
    _dataTableFont = prefs.getString('dataTableFont') ?? AppTheme.dataTableFontFamily;

    for (var item in colourItems) {
      item._loadPreferences(prefs);
    }

    notifyListeners();
  }

  Color? loadColorPreference(SharedPreferences prefs, String key) {
    return prefs.getInt(key) != null ? Color(prefs.getInt(key)!) : null;
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt('brightness', _brightness.index);
    prefs.setDouble('windowWidth', _windowWidth);
    prefs.setDouble('windowHeight', _windowHeight);
    prefs.setString('dataTableFont', _dataTableFont);

    for (var item in colourItems) {
      item._savePreferences(prefs);
    }
  }
}

class ThemeColourItem {
  Color dark;
  Color light;
  final String key;
  final String darkKey;
  final String lightKey;
  final Color defaultDark;
  final Color defaultLight;
  final bool Function() isDarkMode;
  final VoidCallback onChanged;

  ThemeColourItem({
    required this.key,
    required this.defaultDark,
    required this.defaultLight,
    required this.isDarkMode,
    required this.onChanged,
  })  : darkKey = '$key-dark',
        lightKey = '$key-light',
        dark = defaultDark,
        light = defaultLight;

  void _loadPreferences(SharedPreferences prefs) {
    dark = Color(prefs.getInt(darkKey) ?? defaultDark.colorValue);
    light = Color(prefs.getInt(lightKey) ?? defaultLight.colorValue);
  }

  void _savePreferences(SharedPreferences prefs) {
    prefs.setInt(darkKey, dark.colorValue);
    prefs.setInt(lightKey, light.colorValue);
  }

  void _resetDarkColor() {
    dark = defaultDark;
  }

  void _resetLightColor() {
    light = defaultLight;
  }

  Color getColour() {
    return isDarkMode() ? dark : light;
  }

  void setColor(Color color) {
    isDarkMode() ? dark = color : light = color;
    onChanged();
  }
}
