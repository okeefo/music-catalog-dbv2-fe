import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/table_settings_provider.dart';
import 'package:front_end/screens/db-browser/media_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/home_screen.dart';
import 'utils/endpoints.dart';
import 'providers/theme_provider.dart';
import 'providers/db_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window manager
  await windowManager.ensureInitialized();

  // Configure the logger
  _setupLogging();

  // Create ThemeProvider and load preferences
  final themeProvider = await ThemeProvider.create();

  // Set the window size
  await windowManager.setSize(Size(themeProvider.windowWidth, themeProvider.windowHeight));
  await windowManager.center(animate: true);

  // Set the window title
  windowManager.setTitle('Music DB Killer');
  windowManager.setIcon('assets/headphones.ico');
  windowManager.setTitleBarStyle(TitleBarStyle.normal);

  // Initialize the endpoints
  Endpoints.initialize('localhost:8080/mc/api/');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MediaPlayerProvider()),
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => DbProvider()),
        ChangeNotifierProvider(create: (_) => TableSettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  static final Logger _logger = Logger('_MyAppState');
  Timer? _resizeTimer;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _resizeTimer?.cancel();
    super.dispose();
  }

  @override
  void onWindowResize() {
    _resizeTimer?.cancel();
    _resizeTimer = Timer(const Duration(seconds: 3), () async {
      final size = await windowManager.getSize();
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      _logger.info('Window resized to ${size.width}x${size.height}');
      themeProvider.setWindowSize(size.width, size.height);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
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
              themeProvider.setBrightness(value ? Brightness.dark : Brightness.light);
            },
          ),
        );
      },
    );
  }
}
