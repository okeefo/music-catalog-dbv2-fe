import 'package:fluent_ui/fluent_ui.dart';
import '../utils/app_styles.dart';

class NavigationItems {
  static PaneItem buildPaneItem({
    required IconData icon,
    required String title,
    required Widget body,
    required bool isDarkMode,
    required Color darkSidebarIconColor,
    required Color lightSidebarIconColor,
    required Color darkSidebarTextColor,
    required Color lightSidebarTextColor,
  }) {
    return PaneItem(
      icon: Icon(
        icon,
        color: isDarkMode ? darkSidebarIconColor : lightSidebarIconColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? darkSidebarTextColor : lightSidebarTextColor,
        ),
      ),
      body: body,
    );
  }
}