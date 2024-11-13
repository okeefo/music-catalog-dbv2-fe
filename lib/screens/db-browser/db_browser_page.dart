import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:front_end/screens/db-browser/filters.dart';
import 'package:front_end/screens/popups.dart';
import 'package:provider/provider.dart';
import '../../providers/db_provider.dart';
import 'track_table.dart';
import 'track_provider.dart';
import 'track_model.dart';
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

  final Logger _logger = Logger('DbBrowserPageState');

  int _totalTracks = 0;

  @override
  void initState() {
    _logger.info("initState");
    super.initState();
    _loadTracks();
    _initializeWebSocket();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_trackProviderState.isLoading) {
        _loadMoreTracks();
      }
    });
  }

  @override
  void dispose() {
    _channel?.sink.close(status.goingAway);
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
      } else if (code == 'INFO') {
        showInfoDialog(context, msg, 'Scan Complete!');
      } else if (code == 'ERROR') {
        showErrorDialog(context, msg, 'Scan failed!');
      } else {
        _logger.warning('Unknown message code: $code');
      }
    });
  }

  void _loadTracks() {
    TrackProvider.loadTracks(
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
    TrackProvider.loadMoreTracks(
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
              child: Row(
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
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              final selectedDb = dbProvider.databases.firstWhere((db) => db['Name'] == newValue);
                              dbProvider.setActiveDatabase(context, selectedDb['Name']!, selectedDb['Path']!);
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
                          icon: Icon(FluentIcons.music_in_collection_fill, size: themeProvider.iconSizeLarge),
                          onPressed: () => TrackProvider.scanForMusic(context, _channel),
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
                          icon: Icon(FluentIcons.refresh, size: themeProvider.iconSizeLarge),
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
