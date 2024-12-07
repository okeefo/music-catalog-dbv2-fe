import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'package:logging/logging.dart';

class FontPickerRow extends StatefulWidget {
  final String text;
  final String font;
  final ValueChanged<String> onFontChanged;
  final bool addBorder;

  FontPickerRow({
    super.key,
    required this.text,
    required this.font,
    required this.onFontChanged,
    this.addBorder = false,
  });

  @override
  _FontPickerRowState createState() => _FontPickerRowState();
}

class _FontPickerRowState extends State<FontPickerRow> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    List<String> fonts = ['JetBrainsMono Nerd Font', 'Roboto', ...commonWindowsFonts, ...monospacedWindowsFonts];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.text,
          style: TextStyle(
            color: themeProvider.fontColour,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            String? selectedFont = await _showFontPickerDialog(context, widget.font, fonts, themeProvider);
            if (selectedFont != null) {
              widget.onFontChanged(selectedFont);
            }
          },
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: widget.addBorder ? Border.all(color: themeProvider.tableBorderColour) : null,
            ),
            child: Icon(
              FluentIcons.chevron_down,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> _showFontPickerDialog(BuildContext context, String initialFont, List<String> fonts, ThemeProvider themeProvider) {
    String previewFont = initialFont; // Move previewFont inside the builder
    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ContentDialog(
              constraints: const BoxConstraints(maxWidth: 750),
              title: Text('Select Font', textAlign: TextAlign.center),
              content: Row(
                children: [
                  _buildFontList(
                    context,
                    fonts,
                    setState,
                    themeProvider,
                    (String selectedFont) {
                      setState(() {
                        previewFont = selectedFont;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildExampleBox(previewFont, themeProvider),
                ],
              ),
              actions: [
                Button(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Button(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context, previewFont);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFontList(
    BuildContext context,
    List<String> fonts,
    StateSetter setState,
    ThemeProvider themeProvider,
    ValueChanged<String> onFontSelected,
  ) {
    final logger = Logger('FontPickerRow');
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: themeProvider.tableBorderColour, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Text(
              'Font List',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.boldFontColour,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: fonts.length,
                itemBuilder: (context, index) {
                  final value = fonts[index];
                  return GestureDetector(
                    onTap: () {
                      logger.info('Selected font: $value');
                      onFontSelected(value);
                    },
                    child: Container(
                      color: index % 2 == 0 ? themeProvider.rowBackgroundColour : themeProvider.rowAltBackgroundColour,
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        value,
                        style: TextStyle(fontFamily: value),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleBox(String previewFont, ThemeProvider themeProvider) {
    final logger = Logger('FontPickerRow');
    logger.info('Preview font: $previewFont');
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: themeProvider.tableBorderColour, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Text(
              'Example',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.boldFontColour,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                child: Center(
                  widthFactor: 10.0,
                  child: Text(
                    'The quick brown fox jumps over the lazy dog\n\n 1 2 3 4 5 6 7 8 9 0\n\n = != < > + - * / @ ',
                    style: TextStyle(fontFamily: previewFont, color: themeProvider.fontColour),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
  'Fira Code',
  'DejaVu Sans Mono',
];
