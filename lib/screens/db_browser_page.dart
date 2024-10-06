import 'package:fluent_ui/fluent_ui.dart';
import '../utils/app_styles.dart';

class DbBrowserPage extends StatelessWidget {
  final Color fontColour;

  DbBrowserPage({
    super.key,
    required this.fontColour,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'DB Browser Page',
        style: TextStyle(
          color: fontColour,
        ),
      ),
    );
  }
}
