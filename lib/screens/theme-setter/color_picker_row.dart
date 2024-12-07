import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:front_end/screens/popups.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class ColorPickerRow extends StatelessWidget {
  final String text;
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool addBorder;
  final FlyoutController menuController = FlyoutController();
  final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  ColorPickerRow({
    super.key,
    required this.text,
    required this.color,
    required this.onColorChanged,
    this.addBorder = false,
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
            color: themeProvider.fontColour,
          ),
        ),
        const SizedBox(width: 10),
        FlyoutTarget(
          controller: menuController,
          child: GestureDetector(
            onTap: () {
              _showColorPickerDialog(context, color, onColorChanged, themeProvider);
            },
            onSecondaryTapDown: (details) {
              _showContextMenu(context, details, color, onColorChanged, themeProvider);
            },
            child: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: color,
                  border: addBorder ? Border.all(color: themeProvider.tableBorderColour) : null,
                )),
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

  void _showContextMenu(BuildContext context, TapDownDetails details, Color currentColor, ValueChanged<Color> onColorChanged, ThemeProvider themeProvider) {
    // This calculates the position of the flyout according to the parent navigator
    final logger = Logger('ColorPickerRow');
    menuController.showFlyout(
      barrierDismissible: true,
      dismissOnPointerMoveAway: true,
      dismissWithEsc: true,
      position: details.globalPosition,
      navigatorKey: rootNavigatorKey.currentState,
      builder: (context) {
        return MenuFlyout(items: [
          MenuFlyoutItem(
              leading: const Icon(FluentIcons.copy),
              text: const Text('Copy'),
              onPressed: () {
               String hexColour = colorToHex(currentColor);
                Clipboard.setData(ClipboardData(text: hexColour));
                logger.info('Color copied to clipboard: $hexColour');
              }),
          MenuFlyoutItem(
            leading: const Icon(FluentIcons.paste),
            text: const Text('Paste', style: TextStyle(fontSize: 12)),
            selected: false,
            onPressed: () => {
              Clipboard.getData('text/plain').then((value) {
                if (value != null) {
                  String? hexColour = value.text;
                  if (hexColour != null) {
                    Color? newColor = hexColour.toColor();
                    if (newColor != null) {
                      logger.info('Pasted colour: $hexColour');
                      onColorChanged(newColor);
                    } else {
                      logger.warning ( "Invalid colour: $hexColour", "Paste Error");
                    }
                  }
                }
              })
            },
          ),
          const MenuFlyoutSeparator(),
          MenuFlyoutItem(
              leading: const Icon(FluentIcons.open_in_new_window),
              text: const Text('Open'),
              closeAfterClick: true,
              onPressed: () {
                Navigator.pop(context);
                _showColorPickerDialog(context, color, onColorChanged, themeProvider);
              }),
        ]);
      },
    );
  }

  void _showNotImplementedDialog(BuildContext context) {
    Flyout.of(context).close();
    showErrorDialog(context, "Nothing to see here", "Not Implemented");
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
