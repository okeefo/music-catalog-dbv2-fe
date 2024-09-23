import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_styles.dart';
import 'settings_page.dart';
import 'color_picker_row.dart';
import 'navigation_items.dart';
import 'db_browser_page.dart';
import 'db_connections_page.dart';
import 'light_dark_mode_page.dart';

// lib/screens/home_screen.dart

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
  Color lightFontColor = AppTheme.lightFontColor;

  // Dark mode colors
  Color darkSidebarTextColor = AppTheme.darkSideBarText;
  Color darkSidebarIconColor = AppTheme.darkSideBarIconColor;
  Color darkFontColor = AppTheme.darkFontColor;

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
      darkSidebarTextColor = Color(prefs.getInt('darkSidebarTextColor') ?? AppTheme.darkSideBarText.value);
      darkSidebarIconColor = Color(prefs.getInt('darkSidebarIconColor') ?? AppTheme.darkSideBarIconColor.value);
      lightSidebarTextColor = Color(prefs.getInt('lightSidebarTextColor') ?? AppTheme.lightSideBarText.value);
      lightSidebarIconColor = Color(prefs.getInt('lightSidebarIconColor') ?? AppTheme.lightSideBarIconColor.value);

      darkFontColor = Color(prefs.getInt('darkFontColor') ?? AppTheme.darkFontColor.value);
      lightFontColor = Color(prefs.getInt('lightFontColor') ?? AppTheme.lightFontColor.value);

      widget.onThemeChanged(prefs.getBool('isDarkMode') ?? widget.isDarkMode);
    });
  }

  void _resetToDefault() {
    setState(() {
      darkFontColor = AppTheme.darkFontColor;
      lightFontColor = AppTheme.lightFontColor;
      darkSidebarTextColor = AppTheme.darkSideBarText;
      darkSidebarIconColor = AppTheme.darkSideBarIconColor;
      lightSidebarTextColor = AppTheme.lightSideBarText;
      lightSidebarIconColor = AppTheme.lightSideBarIconColor;
      _saveColorToPrefs('darkFontColor', AppTheme.darkFontColor);
      _saveColorToPrefs('lightFontColor', AppTheme.lightFontColor);
      _saveColorToPrefs('darkSidebarTextColor', AppTheme.darkSideBarText);
      _saveColorToPrefs('darkSidebarIconColor', AppTheme.darkSideBarIconColor);
      _saveColorToPrefs('lightSidebarTextColor', AppTheme.lightSideBarText);
      _saveColorToPrefs('lightSidebarIconColor', AppTheme.lightSideBarIconColor);
    });
  }

  List<NavigationPaneItem> _buildPaneItems() {
    return [
      NavigationItems.buildPaneItem(
          icon: FluentIcons.settings,
          title: 'Settings',
          body: SettingsPage(darkFontColor: darkFontColor, lightFontColor: lightFontColor),
          isDarkMode: widget.isDarkMode,
          darkSidebarIconColor: darkSidebarIconColor,
          lightSidebarIconColor: lightSidebarIconColor,
          darkSidebarTextColor: darkSidebarTextColor,
          lightSidebarTextColor: lightSidebarTextColor),
      
      NavigationItems.buildPaneItem(
        icon: FluentIcons.database,
        title: 'DB Browser',
        body: DbBrowserPage(
          darkFontColor: darkFontColor,
          lightFontColor: lightFontColor,
        ),
        isDarkMode: widget.isDarkMode,
        darkSidebarIconColor: darkSidebarIconColor,
        lightSidebarIconColor: lightSidebarIconColor,
        darkSidebarTextColor: darkSidebarTextColor,
        lightSidebarTextColor: lightSidebarTextColor,
      ),
      
      NavigationItems.buildPaneItem(
        icon: FluentIcons.database_view,
        title: 'DB Connections',
        body: DbConnectionsPage(
          darkFontColor: darkFontColor,
          lightFontColor: lightFontColor,
        ),
        isDarkMode: widget.isDarkMode,
        darkSidebarIconColor: darkSidebarIconColor,
        lightSidebarIconColor: lightSidebarIconColor,
        darkSidebarTextColor: darkSidebarTextColor,
        lightSidebarTextColor: lightSidebarTextColor,
      ),
    ];
  }

  List<NavigationPaneItem> _buildFooterItems() {
    return [
      PaneItemSeparator(),
      NavigationItems.buildPaneItem(
        icon: FluentIcons.light,
        title: 'Light/Dark Mode',
        body: LightDarkModePage(
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
          darkSidebarTextColor: darkSidebarTextColor,
          lightSidebarTextColor: lightSidebarTextColor,
          darkSidebarIconColor: darkSidebarIconColor,
          lightSidebarIconColor: lightSidebarIconColor,
          darkFontColor: darkFontColor,
          lightFontColor: lightFontColor,
        ),
        isDarkMode: widget.isDarkMode,
        darkSidebarIconColor: darkSidebarIconColor,
        lightSidebarIconColor: lightSidebarIconColor,
        darkSidebarTextColor: darkSidebarTextColor,
        lightSidebarTextColor: lightSidebarTextColor,
      ),
    ];
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
}
