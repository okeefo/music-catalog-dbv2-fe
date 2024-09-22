// lib/screens/light_dark_mode_page.dart

import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_styles.dart';
import 'color_picker_row.dart';

class LightDarkModePage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Color darkSidebarTextColor;
  final Color lightSidebarTextColor;
  final Color darkSidebarIconColor;
  final Color lightSidebarIconColor;

  const LightDarkModePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.darkSidebarTextColor,
    required this.lightSidebarTextColor,
    required this.darkSidebarIconColor,
    required this.lightSidebarIconColor,
  });

  Future<void> _saveThemeToPrefs(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
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
                    checked: isDarkMode,
                    onChanged: (isDarkMode) {
                      onThemeChanged(isDarkMode);
                      _saveThemeToPrefs(isDarkMode);
                    },
                    content: Text(
                      isDarkMode ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                        color: isDarkMode ? AppTheme.darkText : AppTheme.lightText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Change Sidebar Text Color',
                    color: isDarkMode ? darkSidebarTextColor : lightSidebarTextColor,
                    onColorChanged: (color) {
                      // Handle color change
                    },
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Change Sidebar Icon Color',
                    color: isDarkMode ? darkSidebarIconColor : lightSidebarIconColor,
                    onColorChanged: (color) {
                      // Handle color change
                    },
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 20),
                  Button(
                    onPressed: () {
                      // Handle reset to default
                    },
                    child: Text(
                      'Reset to Default',
                      style: TextStyle(
                        color: isDarkMode ? AppTheme.darkText : AppTheme.lightText,
                      ),
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