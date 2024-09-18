import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../utils/app_styles.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Color sidebarTextColor = AppTheme.lightText;
  Color sidebarIconColor = AppTheme.lightText;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: _selectedIndex,
        onChanged: (index) => setState(() => _selectedIndex = index),
        displayMode: PaneDisplayMode.auto,
        items: [
          _buildPaneItem(
            icon: FluentIcons.settings,
            title: 'Settings',
            body: const SettingsPage(),
          ),
          _buildPaneItem(
            icon: FluentIcons.database,
            title: 'DB Browser',
            body: const DbBrowserPage(),
          ),
          _buildPaneItem(
            icon: FluentIcons.database_view,
            title: 'DB Connections',
            body: const DbConnectionsPage(),
          ),
        ],
        footerItems: [
          _buildPaneItem(
            icon: FluentIcons.light,
            title: 'Light/Dark Mode',
            body: Center(
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
                            onChanged: widget.onThemeChanged,
                            content: Text(
                              widget.isDarkMode ? 'Dark Mode' : 'Light Mode',
                              style: TextStyle(
                                color: widget.isDarkMode ? AppTheme.darkText : AppTheme.lightText,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildColorPickerRow(
                            'Change Sidebar Text Color',
                            sidebarTextColor,
                            (color) {
                              setState(() {
                                sidebarTextColor = color;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildColorPickerRow(
                            'Change Sidebar Icon Color',
                            sidebarIconColor,
                            (color) {
                              setState(() {
                                sidebarIconColor = color;
                              });
                            },
                          ),
                        ],
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

  Widget _buildColorPickerRow(String text, Color color, ValueChanged<Color> onColorChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            _showColorPickerDialog(color, onColorChanged);
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

  void _showColorPickerDialog(Color currentColor, ValueChanged<Color> onColorChanged) {
    showDialog(
      context: context,
      builder: (context) {
        return material.AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
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
        );
      },
    );
  }

  PaneItem _buildPaneItem({
    required IconData icon,
    required String title,
    required Widget body,
  }) {
    return PaneItem(
      icon: Icon(
        icon,
        color: sidebarIconColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: sidebarTextColor,
        ),
      ),
      body: body,
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings Page',
        style: TextStyle(
          color: FluentTheme.of(context).brightness == Brightness.dark
              ? AppTheme.darkText
              : AppTheme.lightText,
        ),
      ),
    );
  }
}

class DbBrowserPage extends StatelessWidget {
  const DbBrowserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'DB Browser Page',
        style: TextStyle(
          color: FluentTheme.of(context).brightness == Brightness.dark
              ? AppTheme.darkText
              : AppTheme.lightText,
        ),
      ),
    );
  }
}

class DbConnectionsPage extends StatelessWidget {
  const DbConnectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'DB Connections Page',
        style: TextStyle(
          color: FluentTheme.of(context).brightness == Brightness.dark
              ? AppTheme.darkText
              : AppTheme.lightText,
        ),
      ),
    );
  }
}