import 'package:fluent_ui/fluent_ui.dart';
import 'screens/home_screen.dart';
import 'utils/app_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Fluent UI App',
      theme: FluentThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        accentColor: Colors.blue,
        scaffoldBackgroundColor: isDarkMode ? AppTheme.dark : AppTheme.light,
      ),
      home: HomeScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    );
  }
}