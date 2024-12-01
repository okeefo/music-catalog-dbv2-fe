import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:front_end/screens/db-browser/filters.dart';
import 'package:front_end/screens/popups.dart';
import 'package:provider/provider.dart';
import '../../providers/db_provider.dart';
import 'track_table.dart';
import 'track_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:logging/logging.dart';

class DbBrowserPage extends StatefulWidget {
  const DbBrowserPage({super.key});

  @override
  DbBrowserPageState createState() => DbBrowserPageState();
}

class DbBrowserPageState extends State<DbBrowserPage> {
  WebSocketChannel? _channel;
  final List<String> _statusUpdates = [];
  final List<String> _selectedFilters = [];
  final List<String> _availableFilters = ['Label', 'Album', 'Artist', 'Year', 'Country', 'Style', 'Genre'];
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<String> _statusNotifier = ValueNotifier<String>('No updates yet');
  final TrackProviderState _trackProviderState = TrackProviderState();
  final TrackProvider _trackProvider = TrackProvider();

  final Logger _logger = Logger('DbBrowserPageState');

  @override
  void initState() {
    _logger.info("initState");
    super.initState();
    _loadTracks();
    _initializeWebSocket();

    _scrollController.addListener(() {
      // Define a threshold value (e.g., 200 pixels) before reaching the end of the list
      const double threshold = 800.0;

      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - threshold && !_trackProviderState.isLoading) {
        _loadMoreTracks();
      }
    });
  }

  @override
  void dispose() {
    _channel?.sink.close(status.normalClosure);
    _scrollController.dispose();
    _statusNotifier.dispose();
    super.dispose();
  }

  void _initializeWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080/ws'));

    _channel!.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      final code = decodedMessage['code'];
      final msg = decodedMessage['message'];
      final upd = msg.replaceAll('\n', '-');
      _logger.info('Received message: $code : $upd');

      _statusNotifier.value = upd;

      if (code == 'UPDATE') {
        _statusUpdates.add(msg);
      } else if (code == 'COMPLETED') {
        showInfoDialog(context, msg, 'Scan Completed!');
        _loadMoreTracks();
      } else if (code == 'INFO') {
        showInfoDialog(context, msg, 'Scan Info!');
      } else if (code == 'ERROR') {
        showErrorDialog(context, msg, 'Scan failed!');
      } else {
        _logger.warning('Unknown message code: $code');
      }
    });
  }

  void _loadTracks() {
    _trackProvider.loadTracks(
      state: _trackProviderState,
      onSuccess: (newTracks, totalTracks) {
        setState(() {
          _trackProviderState.addTracks(newTracks);
          _trackProviderState.setTotalTracks(totalTracks);
        });
      },
      onError: (error) {
        _logger.severe("Failed to fetch tracks: $error");
      },
    );
  }

  void _loadMoreTracks() {
    _trackProvider.loadMoreTracks(
      state: _trackProviderState,
      onSuccess: (newTracks, totalTracks) {
        setState(() {
          _trackProviderState.addTracks(newTracks);
          _trackProviderState.setTotalTracks(totalTracks);
        });
      },
      onError: (error) {
        _logger.severe("Failed to fetch tracks: $error");
      },
    );
  }

  void _onFilterDoubleTap(String filter) {
    setState(() {
      _selectedFilters.add(filter);
      _availableFilters.remove(filter);
    });
  }

  void _onFilterTap(String filter) {
    // Implement sorting/grouping logic here
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScaffoldPage(
      header: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Tracks: ${_trackProviderState.totalTracks}',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeProvider.fontColour,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Consumer<DbProvider>(
                        builder: (context, dbProvider, child) {
                          if (dbProvider.databases.isEmpty) {
                            return const ProgressRing();
                          } else {
                            return ComboBox<String>(
                              items: dbProvider.databases.map((db) {
                                return ComboBoxItem<String>(
                                  value: db['Name'],
                                  child: Text(db['Name']!),
                                );
                              }).toList(),
                              value: dbProvider.activeDatabase,
                              onChanged: (String? newValue) async {
                                if (newValue != null) {
                                  final selectedDb = dbProvider.databases.firstWhere((db) => db['Name'] == newValue);
                                  await dbProvider.setActiveDatabase(context, selectedDb['Name']!, selectedDb['Path']!);
                                  _loadTracks();
                                }
                              },
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          Tooltip(
                            message: 'Scan for music',
                            child: IconButton(
                              icon: Icon(
                                FluentIcons.music_in_collection_fill,
                                size: themeProvider.iconSizeLarge,
                                color: themeProvider.iconColour,
                              ),
                              onPressed: () => _trackProvider.scanForMusic(context, _channel),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Scan',
                            style: TextStyle(
                              color: themeProvider.fontColour,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          Tooltip(
                            message: 'Reload tracks',
                            child: IconButton(
                              icon: Icon(
                                FluentIcons.refresh,
                                size: themeProvider.iconSizeLarge,
                                color: themeProvider.iconColour,
                              ),
                              onPressed: _loadTracks,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Reload',
                            style: TextStyle(
                              color: themeProvider.fontColour,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'DB Browser',
                style: TextStyle(
                  fontSize: 24,
                  color: themeProvider.fontColour,
                ),
              ),
            ),
          ],
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // First Column: Selected Filters
                  Expanded(
                    flex: 1,
                    child: FilterList(
                      filters: _selectedFilters,
                      onFilterTap: _onFilterTap,
                      onFilterDoubleTap: _onFilterDoubleTap,
                    ),
                  ),
                  // Second Column: Available Filters
                  Expanded(
                    flex: 1,
                    child: FilterList(
                      filters: _availableFilters,
                      onFilterTap: _onFilterTap,
                      onFilterDoubleTap: _onFilterDoubleTap,
                    ),
                  ),
                  // Third Column: Tracks Table
                  Expanded(
                    flex: 10,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: TrackTable(
                        tracks: _trackProviderState.tracks,
                        scrollController: _scrollController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomBar: Container(
        padding: const EdgeInsets.all(8.0),
        color: themeProvider.backgroundColour,
        child: ValueListenableBuilder<String>(
          valueListenable: _statusNotifier,
          builder: (context, value, child) {
            return Text(
              value,
              style: TextStyle(
                color: themeProvider.fontColour,
              ),
            );
          },
        ),
      ),
    );
  }
}
