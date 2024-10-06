import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_styles.dart';
import 'color_picker_row.dart';

class LightDarkModePage extends StatefulWidget {
  const LightDarkModePage({
    super.key,
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
                    checked: themeProvider.isDarkMode,
                    onChanged: (isDarkMode) {
                     themeProvider.setBrightness(isDarkMode ? Brightness.dark : Brightness.light);;
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
                    text: 'Bold Font Color',
                    color: themeProvider.boldFontColor,
                    onColorChanged: (color) {
                      if (themeProvider.isDarkMode) {
                        themeProvider.setDarkBoldFontColor(color);
                      } else {
                        themeProvider.setLightBoldFontColor(color);
                      }
                    },
                    isDarkMode: themeProvider.isDarkMode,
                    darkFontColor: themeProvider.darkFontColor,
                    lightFontColor: themeProvider.lightFontColor,
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Icon Color',
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
                      if (themeProvider.isDarkMode) {
                        themeProvider.setDarkBoldFontColor(AppTheme.defaultDarkBoldFontColor);
                       themeProvider.setDarkIconColor(AppTheme.defaultDarkIconColor);
                        themeProvider.setDarkFontColor(AppTheme.defaultDarkFontColor);
                      } else {
                        themeProvider.setLightBoldFontColor(AppTheme.defaultLightBoldFontColor);
                        themeProvider.setLightIconColor(AppTheme.defaultLightIconColor);
                        themeProvider.setLightFontColor(AppTheme.defaultLightFontColor);
                      }
                    },
                    child: Text(
                      'Reset to Default',
                      style: TextStyle(color: themeProvider.fontColor),
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
