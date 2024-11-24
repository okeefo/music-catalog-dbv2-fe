import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
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

    return ScaffoldPage(
      header: PageHeader(title: Text('Light/Dark Mode Settings')),
      content: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(flex: 1, child: Container()), // Empty space
                Expanded(
                  flex: 4,
                  child: _buildGridBox(
                    title: 'Basic',
                    themeProvider: themeProvider,
                    children: [
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
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _buildGridBox(
                    title: 'Table',
                    themeProvider: themeProvider,
                    children: [
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
                    ],
                  ),
                ),
                Flexible(flex: 1, child: Container()), // Empty space
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // Add padding at the bottom
            child: Row(
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
                const SizedBox(width: 20),
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
        ],
      ),
    );
  }

  Widget _buildGridBox({
    required String title,
    required ThemeProvider themeProvider,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: themeProvider.tableBorderColour, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  title,
                  style: FluentTheme.of(context).typography.subtitle,
                ),
              ),
              const SizedBox(height: 10),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
