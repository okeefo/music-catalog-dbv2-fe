import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../utils/app_styles.dart';
import '../providers/theme_provider.dart';

class ColorPickerRow extends StatelessWidget {
  final String text;
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool isDarkMode;
  final Color darkFontColor;
  final Color lightFontColor;

  const ColorPickerRow({
    super.key,
    required this.text,
    required this.color,
    required this.onColorChanged,
    required this.isDarkMode,
    required this.darkFontColor,
    required this.lightFontColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: isDarkMode ? darkFontColor : lightFontColor,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            _showColorPickerDialog(context, color, onColorChanged, themeProvider);
          },
          child: Container(
            width: 24,
            height: 24,
            color: color,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ],
    );
  }

  void _showColorPickerDialog(BuildContext context, Color currentColor, ValueChanged<Color> onColorChanged, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return _ColorPickerDialog(
          currentColor: currentColor,
          onColorChanged: onColorChanged,
          themeProvider: themeProvider,
        );
      },
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;
  final ThemeProvider themeProvider;

  const _ColorPickerDialog({
    required this.currentColor,
    required this.onColorChanged,
    required this.themeProvider,
  });

  @override
  __ColorPickerDialogState createState() => __ColorPickerDialogState();
}

class __ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _pickerColor;

  @override
  void initState() {
    super.initState();
    _pickerColor = widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return material.Dialog(
      backgroundColor: widget.themeProvider.backgroundColour,
      child: material.AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _pickerColor,
            onColorChanged: (color) {
              setState(() {
                _pickerColor = color;
              });
            },
            enableAlpha: false,
          ),
        ),
        actions: <Widget>[
          material.TextButton(
            child: const Text('Done'),
            onPressed: () {
              widget.onColorChanged(_pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}