import 'package:fluent_ui/fluent_ui.dart';
import '../utils/app_styles.dart';

class SettingsPage extends StatelessWidget {
  final Color fontColour;

  const SettingsPage({
    super.key,
    required this.fontColour,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings Page',
        style: TextStyle(
          color: fontColour,
        ),
      ),
    );
  }
}
