import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Light mode colors
  Color lightSidebarTextColor = AppTheme.lightSideBarText;
  Color lightSidebarIconColor = AppTheme.lightSideBarIconColor;

  // Dark mode colors
  Color darkSidebarTextColor = AppTheme.darkSideBarText;
  Color darkSidebarIconColor = AppTheme.darkSideBarIconColor;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _saveColorToPrefs(String key, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, color.value);
  }

  Future<void> _saveThemeToPrefs(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkSidebarTextColor = Color(prefs.getInt('darkSidebarTextColor') ??
          AppTheme.darkSideBarText.value);
      darkSidebarIconColor = Color(prefs.getInt('darkSidebarIconColor') ??
          AppTheme.darkSideBarIconColor.value);
      lightSidebarTextColor = Color(prefs.getInt('lightSidebarTextColor') ??
          AppTheme.lightSideBarText.value);
      lightSidebarIconColor = Color(prefs.getInt('lightSidebarIconColor') ??
          AppTheme.lightSideBarIconColor.value);
      widget.onThemeChanged(prefs.getBool('isDarkMode') ?? widget.isDarkMode);
    });
  }

  void _resetToDefault() {
    setState(() {
      darkSidebarTextColor = AppTheme.darkSideBarText;
      darkSidebarIconColor = AppTheme.darkSideBarIconColor;
      lightSidebarTextColor = AppTheme.lightSideBarText;
      lightSidebarIconColor = AppTheme.lightSideBarIconColor;
      _saveColorToPrefs('darkSidebarTextColor', AppTheme.darkSideBarText);
      _saveColorToPrefs('darkSidebarIconColor', AppTheme.darkSideBarIconColor);
      _saveColorToPrefs('lightSidebarTextColor', AppTheme.lightSideBarText);
      _saveColorToPrefs(
          'lightSidebarIconColor', AppTheme.lightSideBarIconColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: _selectedIndex,
        onChanged: (index) => setState(() => _selectedIndex = index),
        displayMode: PaneDisplayMode.compact,
        items: _buildPaneItems(),
        footerItems: _buildFooterItems(),
      ),
    );
  }

  List<NavigationPaneItem> _buildPaneItems() {
    return [
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
    ];
  }

  List<NavigationPaneItem> _buildFooterItems() {
    return [
      PaneItemSeparator(),
      _buildPaneItem(
        icon: FluentIcons.light,
        title: 'Light/Dark Mode',
        body: _buildLightDarkModeBody(),
      ),
    ];
  }

  Widget _buildLightDarkModeBody() {
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
                    checked: widget.isDarkMode,
                    onChanged: (isDarkMode) {
                      widget.onThemeChanged(isDarkMode);
                      _saveThemeToPrefs(isDarkMode);
                    },
                    content: Text(
                      widget.isDarkMode ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                        color: widget.isDarkMode
                            ? AppTheme.darkText
                            : AppTheme.lightText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildColorPickerRow(
                    'Change Sidebar Text Color',
                    widget.isDarkMode
                        ? darkSidebarTextColor
                        : lightSidebarTextColor,
                    (color) {
                      setState(() {
                        if (widget.isDarkMode) {
                          darkSidebarTextColor = color;
                          _saveColorToPrefs('darkSidebarTextColor', color);
                        } else {
                          lightSidebarTextColor = color;
                          _saveColorToPrefs('lightSidebarTextColor', color);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildColorPickerRow(
                    'Change Sidebar Icon Color',
                    widget.isDarkMode
                        ? darkSidebarIconColor
                        : lightSidebarIconColor,
                    (color) {
                      setState(() {
                        if (widget.isDarkMode) {
                          darkSidebarIconColor = color;
                          _saveColorToPrefs('darkSidebarIconColor', color);
                        } else {
                          lightSidebarIconColor = color;
                          _saveColorToPrefs('lightSidebarIconColor', color);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Button(
                    onPressed: _resetToDefault,
                    child: Text(
                      'Reset to Default',
                      style: TextStyle(
                        color: widget.isDarkMode
                            ? AppTheme.darkText
                            : AppTheme.lightText,
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

  Future<void> _clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lightSidebarTextColor');
    await prefs.remove('lightSidebarIconColor');
    await prefs.remove('darkSidebarTextColor');
    await prefs.remove('darkSidebarIconColor');
  }

  Widget _buildColorPickerRow(
      String text, Color color, ValueChanged<Color> onColorChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: widget.isDarkMode ? AppTheme.darkText : AppTheme.lightText,
          ),
        ),
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

  void _showColorPickerDialog(
      Color currentColor, ValueChanged<Color> onColorChanged) {
    showDialog(
      context: context,
      builder: (context) {
        return material.Dialog(
          backgroundColor: widget.isDarkMode ? AppTheme.dark : AppTheme.grey,
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

  IconButton _buildOpenPaneButton() {
    return IconButton(
      icon: Icon(
        FluentIcons.global_nav_button,
        color: widget.isDarkMode ? darkSidebarIconColor : lightSidebarIconColor,
      ),
      onPressed: () {
        // Handle the open navigation pane action
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
        color: widget.isDarkMode ? darkSidebarIconColor : lightSidebarIconColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color:
              widget.isDarkMode ? darkSidebarTextColor : lightSidebarTextColor,
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
