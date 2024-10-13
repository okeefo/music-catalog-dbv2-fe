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
                      themeProvider.setBrightness(isDarkMode ? Brightness.dark : Brightness.light);
                    },
                    content: Text(
                      themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                        color: themeProvider.fontColour,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Bold Font Color',
                    color: themeProvider.boldFontColour,
                    onColorChanged: (color) {
                     themeProvider.setBoldFontColor(color);
                    },
                    isDarkMode: themeProvider.isDarkMode,
                    darkFontColor: themeProvider.darkFontColour,
                    lightFontColor: themeProvider.lightFontColour,
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Icon Color',
                    color: themeProvider.iconColour,
                    onColorChanged: (color) {
                      themeProvider.setIconColour(color);
                    },
                    isDarkMode: themeProvider.isDarkMode,
                    darkFontColor: themeProvider.darkFontColour,
                    lightFontColor: themeProvider.lightFontColour,
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Font Color',
                    color: themeProvider.fontColour,
                    onColorChanged: (color) {
                      themeProvider.setFontColour(color);
                    },
                    isDarkMode: themeProvider.isDarkMode,
                    darkFontColor: themeProvider.darkFontColour,
                    lightFontColor: themeProvider.lightFontColour,
                  ),
                  const SizedBox(height: 20),
                  ColorPickerRow(
                    text: 'Table Border Color',
                    color: themeProvider.tableBorderColour,
                    onColorChanged: (color) {
                      themeProvider.setTableBorderColour(color);
                    },
                    isDarkMode: themeProvider.isDarkMode,
                    darkFontColor: themeProvider.darkFontColour,
                    lightFontColor: themeProvider.lightFontColour,
                  ),
                  const SizedBox(height: 20),
                  Button(
                    onPressed: () {
                      if (themeProvider.isDarkMode) {
                        themeProvider.resetDarkColors();
                      } else {
                        themeProvider.resetLightColors();
                      }
                    },
                    child: Text(
                      'Reset to Default',
                      style: TextStyle(color: themeProvider.fontColour),
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
