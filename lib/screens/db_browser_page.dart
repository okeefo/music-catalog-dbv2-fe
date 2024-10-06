import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../utils/app_styles.dart';

class DbBrowserPage extends StatelessWidget {
  const DbBrowserPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Center(
      child: Text(
        'DB Browser Page',
        style: TextStyle(
          color: themeProvider.fontColour,
        ),
      ),
    );
  }
}
