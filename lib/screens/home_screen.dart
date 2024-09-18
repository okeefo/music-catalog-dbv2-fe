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
  Color pageTextColor = AppTheme.lightText;
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
            body: SingleChildScrollView(
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
                    const Text('Change Page Text Color'),
                    material.Material(
                      child: ColorPicker(
                        pickerColor: pageTextColor,
                        onColorChanged: (color) {
                          setState(() {
                            pageTextColor = color;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Change Sidebar Text Color'),
                    material.Material(
                      child: ColorPicker(
                        pickerColor: sidebarTextColor,
                        onColorChanged: (color) {
                          setState(() {
                            sidebarTextColor = color;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Change Sidebar Icon Color'),
                    material.Material(
                      child: ColorPicker(
                        pickerColor: sidebarIconColor,
                        onColorChanged: (color) {
                          setState(() {
                            sidebarIconColor = color;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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