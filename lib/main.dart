import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_styles.dart';
import 'utils/config.dart';
import 'utils/endpoints.dart';
import 'providers/theme_provider.dart';

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
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return FluentApp(
            title: 'Fluent UI App',
            theme: FluentThemeData(
              brightness: themeProvider.brightness,
              accentColor: Colors.blue,
              scaffoldBackgroundColor: themeProvider.backgroundColour,
            ),
            home: HomeScreen(
              onThemeChanged: (value) {
                themeProvider.setBrightness(value? Brightness.dark : Brightness.light);
              },
            ),
          );
        },
      ),
    );
  }
}
