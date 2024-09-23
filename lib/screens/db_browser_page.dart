import 'package:fluent_ui/fluent_ui.dart';
import '../utils/app_styles.dart';

class DbBrowserPage extends StatelessWidget {
  final Color darkFontColor;
  final Color lightFontColor;

  DbBrowserPage({
    super.key,
    required this.darkFontColor,
    required this.lightFontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'DB Browser Page',
        style: TextStyle(
          color: FluentTheme.of(context).brightness == Brightness.dark ? darkFontColor : lightFontColor,
        ),
      ),
    );
  }
}
