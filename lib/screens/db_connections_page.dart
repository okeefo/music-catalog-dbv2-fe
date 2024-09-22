import 'package:fluent_ui/fluent_ui.dart';
import '../utils/app_styles.dart';

class DbConnectionsPage extends StatelessWidget {
  const DbConnectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'DB Connections Page',
            style: TextStyle(
              fontSize: AppTheme.titleTextSize, // Title text size
              fontFamily: AppTheme.fontFamily, // Modern font
              color: FluentTheme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkText
                  : AppTheme.lightText,
            ),
          ),
        ),
      ],
    );
  }
}