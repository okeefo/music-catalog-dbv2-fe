import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'screens/home_screen.dart';
import 'utils/config.dart';
import 'utils/endpoints.dart';
import 'providers/theme_provider.dart';
import 'providers/db_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure the logger
  _setupLogging();

  // Load the configuration
  Config config = await loadConfig();

  // Initialize the endpoints
  Endpoints.initialize(config.baseUri);

  runApp(MyApp(config: config));
}

void _setupLogging() {
  // Set the log level to INFO
  Logger.root.level = Level.INFO;

  // Add the custom log handler
  Logger.root.onRecord.listen(customLogHandler);
}

void customLogHandler(LogRecord record) {
  print('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DbProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return FluentApp(
            title: 'Fluent UI App',
            debugShowCheckedModeBanner: false,
            theme: FluentThemeData(
              brightness: themeProvider.brightness,
              accentColor: Colors.blue,
              scaffoldBackgroundColor: themeProvider.backgroundColour,
            ),
            home: HomeScreen(
              onThemeChanged: (value) {
                print("home screen theme changed - $value");
                themeProvider.setBrightness(value ? Brightness.dark : Brightness.light);
              },
            ),
          );
        },
      ),
    );
  }
}