import 'package:fluent_ui/fluent_ui.dart';
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

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: _selectedIndex,
        onChanged: (index) => setState(() => _selectedIndex = index),
        displayMode: PaneDisplayMode.auto,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            body: const SettingsPage(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.database),
            title: const Text('DB Browser'),
            body: const DbBrowserPage(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.database_view),
            title: const Text('DB Connections'),
            body: const DbConnectionsPage(),
          ),
        ],
        footerItems: [
          PaneItem(
            icon: const Icon(FluentIcons.light),
            title: const Text('Light/Dark Mode'),
            body: Center(
              child: ToggleSwitch(
                checked: widget.isDarkMode,
                onChanged: widget.onThemeChanged,
                content: Text(
                  widget.isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: TextStyle(
                    color: widget.isDarkMode ? AppTheme.darkText : AppTheme.lightText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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