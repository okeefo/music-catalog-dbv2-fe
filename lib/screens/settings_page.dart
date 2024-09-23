import 'package:fluent_ui/fluent_ui.dart';
import '../utils/app_styles.dart';

class SettingsPage extends StatelessWidget {
  final Color darkFontColor;
  final Color lightFontColor;

  SettingsPage({
    super.key,
    required this.darkFontColor,
    required this.lightFontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings Page',
        style: TextStyle(
          color: FluentTheme.of(context).brightness == Brightness.dark ? darkFontColor : lightFontColor,
        ),
      ),
    );
  }
}
