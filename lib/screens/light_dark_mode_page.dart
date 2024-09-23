import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_styles.dart';
import 'color_picker_row.dart';

class LightDarkModePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Color darkSidebarTextColor;
  final Color lightSidebarTextColor;
  final Color darkSidebarIconColor;
  final Color lightSidebarIconColor;
  final Color darkFontColor;
  final Color lightFontColor;

  const LightDarkModePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.darkSidebarTextColor,
    required this.lightSidebarTextColor,
    required this.darkSidebarIconColor,
    required this.lightSidebarIconColor,
    required this.darkFontColor,
    required this.lightFontColor,
  });

  @override
  _LightDarkModePageState createState() => _LightDarkModePageState();
}

class _LightDarkModePageState extends State<LightDarkModePage> {
  late Color darkSidebarTextColor;
  late Color lightSidebarTextColor;
  late Color darkSidebarIconColor;
  late Color lightSidebarIconColor;
  late Color darkFontColor;
  late Color lightFontColor;

  @override
  void initState() {
    super.initState();
    darkSidebarTextColor = widget.darkSidebarTextColor;
    lightSidebarTextColor = widget.lightSidebarTextColor;
    darkSidebarIconColor = widget.darkSidebarIconColor;
    lightSidebarIconColor = widget.lightSidebarIconColor;
    darkFontColor = widget.darkFontColor;
    lightFontColor = widget.lightFontColor;
  }

  Future<void> _saveColorToPrefs(String key, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, color.value);
  }

  Future<void> _saveDarkModeToPrefs(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  void _resetToDefault() {
    setState(() {
      darkSidebarTextColor = AppTheme.darkSideBarText;
      lightSidebarTextColor = AppTheme.lightSideBarText;
      darkSidebarIconColor = AppTheme.darkSideBarIconColor;
      lightSidebarIconColor = AppTheme.lightSideBarIconColor;
      darkFontColor = AppTheme.darkFontColor;
      lightFontColor = AppTheme.lightFontColor;
      _saveColorToPrefs('darkSidebarTextColor', AppTheme.darkSideBarText);
      _saveColorToPrefs('lightSidebarTextColor', AppTheme.lightSideBarText);
      _saveColorToPrefs('darkSidebarIconColor', AppTheme.darkSideBarIconColor);
      _saveColorToPrefs('lightSidebarIconColor', AppTheme.lightSideBarIconColor);
      _saveColorToPrefs('darkFontColor', AppTheme.darkFontColor);
      _saveColorToPrefs('lightFontColor', AppTheme.lightFontColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleSwitch(
                    checked: widget.isDarkMode,
                    onChanged: (isDarkMode) {
                      widget.onThemeChanged(isDarkMode);
                      _saveDarkModeToPrefs(isDarkMode);
                    },
                    content: Text(
                      widget.isDarkMode ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                        color: widget.isDarkMode ? darkFontColor : lightFontColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Sidebar Text Color',
                    color: widget.isDarkMode ? darkSidebarTextColor : lightSidebarTextColor,
                    onColorChanged: (color) {
                      setState(() {
                        if (widget.isDarkMode) {
                          darkSidebarTextColor = color;
                          _saveColorToPrefs('darkSidebarTextColor', color);
                        } else {
                          lightSidebarTextColor = color;
                          _saveColorToPrefs('lightSidebarTextColor', color);
                        }
                      });
                    },
                    isDarkMode: widget.isDarkMode,
                    darkFontColor: darkFontColor,
                    lightFontColor: lightFontColor,
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Sidebar Icon Color',
                    color: widget.isDarkMode ? darkSidebarIconColor : lightSidebarIconColor,
                    onColorChanged: (color) {
                      setState(() {
                        if (widget.isDarkMode) {
                          darkSidebarIconColor = color;
                          _saveColorToPrefs('darkSidebarIconColor', color);
                        } else {
                          lightSidebarIconColor = color;
                          _saveColorToPrefs('lightSidebarIconColor', color);
                        }
                      });
                    },
                    isDarkMode: widget.isDarkMode,
                    darkFontColor: darkFontColor,
                    lightFontColor: lightFontColor,
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Font Color',
                    color: widget.isDarkMode ? darkFontColor : lightFontColor,
                    onColorChanged: (color) {
                      setState(() {
                        if (widget.isDarkMode) {
                          darkFontColor = color;
                          _saveColorToPrefs('darkFontColor', color);
                        } else {
                          lightFontColor = color;
                          _saveColorToPrefs('lightFontColor', color);
                        }
                      });
                    },
                    isDarkMode: widget.isDarkMode,
                    darkFontColor: darkFontColor,
                    lightFontColor: lightFontColor,
                  ),
                  const SizedBox(height: 20),
                  Button(
                    onPressed: _resetToDefault,
                    child: Text(
                      'Reset to Default',
                      style: TextStyle(color: widget.isDarkMode ? darkFontColor : lightFontColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}