import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/screens/theme-setter/color_picker_row.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class LightDarkModePage extends StatefulWidget {
  const LightDarkModePage({super.key});

  @override
  _LightDarkModePageState createState() => _LightDarkModePageState();
}

class _LightDarkModePageState extends State<LightDarkModePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Calculate the maximum width of the descriptions
    // Collect all the descriptions
    final allDescriptions = [
      'Icon',
      'Font',
      'Bold Font',
      'Background',
      'Toggle Switch',
      'Table Border',
      'Header Font',
      'Header Background',
      'Row Font',
      'Row Background',
      'Alternate Row Font',
      'Alternate Row Background',
    ];

    // Calculate the maximum width of the descriptions
    final maxDescriptionWidth = _calculateMaxDescriptionWidth(allDescriptions);

    return ScaffoldPage(
      header: PageHeader(
        title: Text(
          'Light/Dark Mode Settings',
          style: TextStyle(color: themeProvider.fontColour),
        ),
      ),
      content: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensure the column only takes up the space it needs
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Ensure the row only takes up the space it needs
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children to match the tallest child

                  children: [
                    _buildGridBox(
                      title: 'General',
                      themeProvider: themeProvider,
                      maxDescriptionWidth: maxDescriptionWidth,
                      children: [
                        _buildColourPickerRow(
                          description: 'Background',
                          colour: themeProvider.backgroundColour,
                          saveColourFunc: themeProvider.setBackgroundColour,
                          themeProvider: themeProvider,
                        ),
                        _buildColourPickerRow(
                          description: 'Font',
                          colour: themeProvider.fontColour,
                          saveColourFunc: themeProvider.setFontColour,
                          themeProvider: themeProvider,
                        ),
                        _buildColourPickerRow(
                          description: 'Bold Font',
                          colour: themeProvider.boldFontColour,
                          saveColourFunc: themeProvider.setBoldFontColor,
                          themeProvider: themeProvider,
                        ),
                        _buildColourPickerRow(
                          description: 'Icon',
                          colour: themeProvider.iconColour,
                          saveColourFunc: themeProvider.setIconColour,
                          themeProvider: themeProvider,
                        ),
                        _buildColourPickerRow(
                          description: 'Toggle Background',
                          colour: themeProvider.toggleSwitchBackgroundColor,
                          saveColourFunc: themeProvider.setToggleBackgroundColour,
                          themeProvider: themeProvider,
                        ),
                        _buildColourPickerRow(
                          description: 'Toggle Knob',
                          colour: themeProvider.toggleSwitchKnobColor,
                          saveColourFunc: themeProvider.setToggleKnobColour,
                          themeProvider: themeProvider,
                        ),
                      ],
                    ),
                    SizedBox(width: 20), // Space between grid boxes
                    _buildGridBox(
                      title: 'Table',
                      themeProvider: themeProvider,
                      maxDescriptionWidth: maxDescriptionWidth,
                      children: [
                        _buildColourPickerRow(
                          description: 'Border',
                          colour: themeProvider.tableBorderColour,
                          saveColourFunc: themeProvider.setTableBorderColour,
                          themeProvider: themeProvider,
                        ),
                        _buildColourPickerRow(
                          description: 'Header Font',
                          colour: themeProvider.headerFontColour,
                          saveColourFunc: themeProvider.setHeaderFontColour,
                          themeProvider: themeProvider,
                        ),
                        _buildColourPickerRow(
                          description: 'Header Background',
                          colour: themeProvider.headerBackgroundColour,
                          saveColourFunc: themeProvider.setHeaderFontBackgroundColour,
                          themeProvider: themeProvider,
                        ),
                        _buildColourPickerRow(
                          description: 'Row Font',
                          colour: themeProvider.rowFontColour,
                          saveColourFunc: themeProvider.setRowFontColour,
                          themeProvider: themeProvider,
                        ),
                        _buildColourPickerRow(
                          description: 'Row Background',
                          colour: themeProvider.rowBackgroundColour,
                          saveColourFunc: themeProvider.setRowBackgroundColour,
                          themeProvider: themeProvider,
                        ),
                        _buildColourPickerRow(
                          description: 'Alternate Row Font',
                          colour: themeProvider.rowAltFontColour,
                          saveColourFunc: themeProvider.setRowAltFontColour,
                          themeProvider: themeProvider,
                        ),
                        _buildColourPickerRow(
                          description: 'Alternate Row Background',
                          colour: themeProvider.rowAltBackgroundColour,
                          saveColourFunc: themeProvider.setRowAltBackgroundColour,
                          themeProvider: themeProvider,
                        ),
                        _buildFontPickerRow(
                          description: 'Font',
                          font: themeProvider.dataTableFontFamily,
                          saveFontFunc: themeProvider.setDataTableFontFamily,
                          themeProvider: themeProvider,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min, // Ensure the row only takes up the space it needs
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleSwitch(
                    checked: themeProvider.isDarkMode,
                    style: ToggleSwitchThemeData(
                      checkedDecoration: WidgetStateProperty.all(BoxDecoration(
                        color: themeProvider.toggleSwitchBackgroundColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                      )),
                      uncheckedDecoration: WidgetStateProperty.all(BoxDecoration(
                        color: themeProvider.toggleSwitchBackgroundColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                      )),
                      checkedKnobDecoration: WidgetStateProperty.all(BoxDecoration(
                        color: themeProvider.toggleSwitchKnobColor,
                        shape: BoxShape.circle,
                      )),
                      uncheckedKnobDecoration: WidgetStateProperty.all(BoxDecoration(
                        color: themeProvider.toggleSwitchKnobColor,
                        shape: BoxShape.circle,
                      )),
                    ),
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
                        themeProvider.resetDarkColours();
                      } else {
                        themeProvider.resetLightColours();
                      }
                    },
                    child: Text(
                      'Reset to Default',
                      style: TextStyle(color: themeProvider.fontColour),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateMaxDescriptionWidth(List<String> descriptions) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    double maxWidth = 0;

    for (final description in descriptions) {
      textPainter.text = TextSpan(text: description, style: TextStyle(fontSize: 14));
      textPainter.layout();
      if (textPainter.width > maxWidth) {
        maxWidth = textPainter.width;
      }
    }

    return maxWidth;
  }

  Widget _buildGridBox({
    required String title,
    required ThemeProvider themeProvider,
    required double maxDescriptionWidth,
    required List<TableRow> children,
  }) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: themeProvider.tableBorderColour, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Take up minimum space
          crossAxisAlignment: CrossAxisAlignment.center, // Center the title horizontally
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: themeProvider.boldFontColour,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft, // Align the table to the left
              child: Table(
                columnWidths: {
                  0: FixedColumnWidth(maxDescriptionWidth + 16), // Add some padding
                  1: IntrinsicColumnWidth(),
                },
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildColourPickerRow({
    required String description,
    required Color colour,
    required void Function(Color color) saveColourFunc,
    required ThemeProvider themeProvider,

  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            description,
            style: TextStyle(fontSize: 14, color: themeProvider.fontColour),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _buildColorPicker(
            colour: colour,
            saveColourFunc: saveColourFunc,
            addBorder: true,
          ),
        ),
      ],
    );
  }

  TableRow _buildFontPickerRow({required String description, required String font, required void Function(String font) saveFontFunc, required themeProvider}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            description,
            style: TextStyle(fontSize: 14, color: themeProvider.fontColour),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _buildFontPicker(
            font: font,
            saveFontFunc: saveFontFunc,
          ),
        ),
      ],
    );
  }
}

_buildColorPicker({
  required Color colour,
  required void Function(Color color) saveColourFunc,
  required bool addBorder,
}) {
  return ColorPickerRow(
    text: '',
    color: colour,
    onColorChanged: (color) {
      saveColourFunc(color);
    },
    addBorder: addBorder,
  );
}




_buildFontPicker({
  required String font,
  required void Function(String font) saveFontFunc,
}) {
  List<String> fonts = [];
  fonts.add('JetBrainsMono Nerd Font');
  fonts.add('Roboto');
  fonts.addAll([...commonWindowsFonts, ...monospacedWindowsFonts]);

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ComboBox<String>(
        value: font,
        onChanged: (String? newFont) {
          if (newFont != null) {
            saveFontFunc(newFont);
          }
        },
        items: fonts.map<ComboBoxItem<String>>((String value) {
          return ComboBoxItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontFamily: 'value'),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

const List<String> commonWindowsFonts = [
  'Arial',
  'Times New Roman',
  'Verdana',
  'Georgia',
  'Trebuchet MS',
  'Comic Sans MS',
  'Impact',
  'Calibri',
  'Cambria',
  'Tahoma',
];

const List<String> monospacedWindowsFonts = [
  'Courier New',
  'Consolas',
  'Lucida Console',
  'Monaco',
  'Inconsolata',
  'Source Code Pro',
  'Roboto Mono',
  'JetBrains Mono',
  'Fira Code',
  'DejaVu Sans Mono',
];
