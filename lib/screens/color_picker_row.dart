import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../utils/app_styles.dart';

class ColorPickerRow extends StatelessWidget {
  final String text;
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool isDarkMode;

  const ColorPickerRow({
    super.key,
    required this.text,
    required this.color,
    required this.onColorChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: isDarkMode ? AppTheme.darkText : AppTheme.lightText,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            _showColorPickerDialog(context, color, onColorChanged);
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

  void _showColorPickerDialog(BuildContext context, Color currentColor, ValueChanged<Color> onColorChanged) {
    showDialog(
      context: context,
      builder: (context) {
        return material.Dialog(
          backgroundColor: isDarkMode ? AppTheme.dark : AppTheme.grey,
          child: material.AlertDialog(
            title: const Text('Pick a color'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: currentColor,
                onColorChanged: onColorChanged,
                enableAlpha: false,
              ),
            ),
            actions: <Widget>[
              material.TextButton(
                child: const Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}