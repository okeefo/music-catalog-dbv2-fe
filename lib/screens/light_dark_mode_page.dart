import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_styles.dart';
import 'color_picker_row.dart';

class LightDarkModePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const LightDarkModePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  _LightDarkModePageState createState() => _LightDarkModePageState();
}

class _LightDarkModePageState extends State<LightDarkModePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
                    },
                    content: Text(
                      themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                        color: themeProvider.fontColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Sidebar Text Color',
                    color: themeProvider.boldFontColor,
                    onColorChanged: (color) {
                      if (themeProvider.isDarkMode) {
                        themeProvider.setDarkBoldFontColor(color);
                      } else {
                        themeProvider.setLightBoldFontColor(color);
                      }
                    },
                    isDarkMode: themeProvider.isDarkMode,
                    darkFontColor: themeProvider.darkBoldFontColor,
                    lightFontColor: themeProvider.lightBoldFontColor,
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Sidebar Icon Color',
                    color: themeProvider.iconColor,
                    onColorChanged: (color) {
                      if (themeProvider.isDarkMode) {
                        themeProvider.setDarkIconColor(color);
                      } else {
                        themeProvider.setLightIconColor(color);
                      }
                    },
                    isDarkMode: themeProvider.isDarkMode,
                    darkFontColor: themeProvider.darkFontColor,
                    lightFontColor: themeProvider.lightFontColor,
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Font Color',
                    color: themeProvider.fontColor,
                    onColorChanged: (color) {
                      if (themeProvider.isDarkMode) {
                        themeProvider.setDarkFontColor(color);
                      } else {
                        themeProvider.setLightFontColor(color);
                      }
                    },
                    isDarkMode: themeProvider.isDarkMode,
                    darkFontColor: themeProvider.darkFontColor,
                    lightFontColor: themeProvider.lightFontColor,
                  ),
                  const SizedBox(height: 20),
                  Button(
                    onPressed: () {
                      themeProvider.setDarkBoldFontColor(AppTheme.defaultDarkBoldFontColor);
                      themeProvider.setLightBoldFontColor(AppTheme.defaultLightBoldFontColor);
                      themeProvider.setDarkIconColor(AppTheme.defaultDarkIconColor);
                      themeProvider.setLightIconColor(AppTheme.defaultLightIconColor);
                      themeProvider.setDarkFontColor(AppTheme.defaultDarkFontColor);
                      themeProvider.setLightFontColor(AppTheme.defaultLightFontColor);
                    },
                    child: Text(
                      'Reset to Default',
                      style: TextStyle(color: themeProvider.isDarkMode ? themeProvider.darkFontColor : themeProvider.lightFontColor),
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
