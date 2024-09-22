import 'package:fluent_ui/fluent_ui.dart';
import '../utils/app_styles.dart';

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