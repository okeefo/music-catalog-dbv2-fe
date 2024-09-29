import 'package:fluent_ui/fluent_ui.dart';
import 'screens/home_screen.dart';
import 'utils/app_styles.dart';
import 'utils/config.dart';
import 'utils/endpoints.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the configuration
  Config config = await loadConfig();

  // Initialize the endpoints
  Endpoints.initialize(config.baseUri);

  runApp(MyApp(config: config));
}

class MyApp extends StatefulWidget {
  final Config config;
  const MyApp({super.key, required this.config});

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
