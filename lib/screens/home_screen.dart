import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'settings_page.dart';
import 'navigation_items.dart';
import 'db-browser/db_browser_page.dart';
import 'db_connections_page.dart';
import 'theme-settings/light_dark_mode_page.dart';

// lib/screens/home_screen.dart

class HomeScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NavigationView(
      pane: NavigationPane(
        selected: _selectedIndex,
        onChanged: (index) => setState(() => _selectedIndex = index),
        displayMode: PaneDisplayMode.compact,
        items: _buildPaneItems(themeProvider),
        footerItems: _buildFooterItems(themeProvider),
      ),
    );
  }

  List<NavigationPaneItem> _buildPaneItems(ThemeProvider themeProvider) {
    return [
      NavigationItems.buildPaneItem(
        icon: FluentIcons.settings,
        title: 'Settings',
        fontColor: themeProvider.fontColour,
        iconColor: themeProvider.iconColour,
        body: const SettingsPage(),
      ),
      NavigationItems.buildPaneItem(
        icon: FluentIcons.database,
        title: 'DB Browser',
        fontColor: themeProvider.fontColour,
        iconColor: themeProvider.iconColour,
        body: const DbBrowserPage(),
      ),
      NavigationItems.buildPaneItem(
        icon: FluentIcons.database_view,
        title: 'DB Connections',
        body: const DbConnectionsPage(),
        fontColor: themeProvider.fontColour,
        iconColor: themeProvider.iconColour,
      ),
    ];
  }

  List<NavigationPaneItem> _buildFooterItems(ThemeProvider themeProvider) {
    return [
      PaneItemSeparator(),
      NavigationItems.buildPaneItem(
        icon: FluentIcons.light,
        title: 'Light/Dark Mode',
        body: const LightDarkModePage(),
        fontColor: themeProvider.fontColour,
        iconColor: themeProvider.iconColour,
      ),
    ];
  }
}
