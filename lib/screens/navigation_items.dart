import 'package:fluent_ui/fluent_ui.dart';

class NavigationItems {
  static PaneItem buildPaneItem({
    required IconData icon,
    required String title,
    required Widget body,
    required Color iconColor,
    required Color fontColor,
  }) {
    return PaneItem(
      icon: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: fontColor,
        ),
      ),
      body: body,
    );
  }
}
