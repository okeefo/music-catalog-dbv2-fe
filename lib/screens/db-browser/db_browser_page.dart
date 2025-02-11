import 'dart:collection';
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
import 'publisher_browser.dart';
import 'track_model.dart';
import '../../utils/endpoints.dart';
import 'media_player.dart';

// Constants for repeated values
const double paddingValue = 16.0;
const double searchBoxWidth = 400.0;
const double threshold = 800.0;
const double fixedFirstColumnWidth = 320.0;

class DbBrowserPage extends StatefulWidget {
  const DbBrowserPage({super.key});

  @override
  DbBrowserPageState createState() => DbBrowserPageState();
}

class DbBrowserPageState extends State<DbBrowserPage> {
  WebSocketChannel? _channel;
  final List<String> _statusUpdates = [];
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<String> _statusNotifier = ValueNotifier<String>('No updates yet');
  final TrackProviderState _trackProviderState = TrackProviderState();
  final TrackProvider _trackProvider = TrackProvider();
  final SplayTreeMap<String, Set<String>> _publisherAlbums = SplayTreeMap();
  final Set<String> _selectedPublishers = {};
  final Set<String> _selectedAlbums = {};
  final GlobalKey<MediaPlayerState> _mediaPlayerKey = GlobalKey<MediaPlayerState>();
  late MediaPlayer _mediaPlayer;

  final Logger _logger = Logger('DbBrowserPageState');

  // Search controllers and state variables
  final TextEditingController _fileBrowserSearchController = TextEditingController();
  final TextEditingController _trackTableSearchController = TextEditingController();
  String _fileBrowserSearchQuery = '';
  String _trackTableSearchQuery = '';

  @override
  void initState() {
    _logger.info("initState");
    super.initState();
    _loadTracks();
    _initializeWebSocket();

    _scrollController.addListener(_scrollListener);
    _mediaPlayer = MediaPlayer(key: _mediaPlayerKey);
  }

  @override
  void dispose() {
    _channel?.sink.close(status.normalClosure);
    _scrollController.dispose();
    _statusNotifier.dispose();
    _fileBrowserSearchController.dispose();
    _trackTableSearchController.dispose();
    super.dispose();
  }

  void _initializeWebSocket() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(Endpoints.wsScanUpdatesUri()));

      _channel!.stream.listen(
        _onWebSocketMessage,
        onError: _onWebSocketError,
        onDone: _onWebSocketDone,
      );
    } catch (e) {
      _logger.severe('Failed to connect to WebSocket: $e');
      showErrorDialog(context, 'Failed to connect to WebSocket: $e', 'Connection Error');
    }
  }

  void _onWebSocketMessage(dynamic message) {
    final decodedMessage = jsonDecode(message);
    final code = decodedMessage['code'];
    final msg = decodedMessage['message'];
    final upd = msg.replaceAll('\n', '-');
    _logger.info('Received message: $code : $upd');

    _statusNotifier.value = upd;

    switch (code) {
      case 'UPDATE':
        _statusUpdates.add(msg);
        break;
      case 'COMPLETED':
        showInfoDialog(context, msg, 'Scan Completed!');
        _loadMoreTracks();
        break;
      case 'INFO':
        showInfoDialog(context, msg, 'Scan Info!');
        break;
      case 'ERROR':
        showErrorDialog(context, msg, 'Scan failed!');
        break;
      default:
        _logger.warning('Unknown message code: $code');
    }
  }

  void _onWebSocketError(dynamic error) {
    _logger.severe('WebSocket error: $error');
    showErrorDialog(context, 'WebSocket error: $error', 'Connection Error');
  }

  void _onWebSocketDone() {
    _logger.info('WebSocket connection closed');
  }

  void _loadTracks() {
    _trackProvider.loadTracks(
      state: _trackProviderState,
      onSuccess: (newTracks, totalTracks) {
        setState(() {
          _trackProviderState.addTracks(newTracks);
          _trackProviderState.setTotalTracks(totalTracks);
          _populatePublisherAlbums(newTracks);
        });
      },
      onError: (error) {
        _logger.severe("Failed to fetch tracks: $error");
      },
    );
  }

  void _populatePublisherAlbums(List<Track> tracks) {
    _publisherAlbums.clear();
    for (var track in tracks) {
      _publisherAlbums.putIfAbsent(track.label, () => <String>{}).add(track.albumTitle);      
    }
  }

  void _loadMoreTracks() {
    _trackProvider.loadMoreTracks(
      state: _trackProviderState,
      onSuccess: (newTracks, totalTracks) {
        setState(() {
          _trackProviderState.addTracks(newTracks);
          _trackProviderState.setTotalTracks(totalTracks);
          _populatePublisherAlbums(newTracks);
        });
      },
      onError: (error) {
        _logger.severe("Failed to fetch tracks: $error");
      },
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - threshold && !_trackProviderState.isLoading) {
      _loadMoreTracks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScaffoldPage(
      header: null,
      padding: EdgeInsets.zero,
      // header: _buildHeader(themeProvider),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 0, 16.0, 0),
        child: Column(
          children: [
            _buildHeader(themeProvider),
            _buildSearchBars(),
            _buildBrowserAndTable(themeProvider),
          ],
        ),
      ),
      bottomBar: _buildBottomBar(themeProvider),
    );
  }

  Widget _buildHeader(ThemeProvider themeProvider) {
    return Row(
      //  crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: fixedFirstColumnWidth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDBControls(themeProvider),
          ),
        ),
        // const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4), // Add padding to align with search bar
            child: _mediaPlayer,
          ),
        ),
      ],
    );
  }

  Widget _buildDBControls(ThemeProvider themeProvider) {
    return Column(
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
        Consumer<DbProvider>(
          builder: (context, dbProvider, child) {
            return ComboBox<String>(
              items: dbProvider.databases.map((db) {
                return ComboBoxItem<String>(
                  value: db['Name'],
                  child: Text(
                    db['Name']!,
                    overflow: TextOverflow.ellipsis,
                  ),
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
          },
        ),
        Row(
          children: [
            //const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.00, 6.0, 0.0, 0),
              child: _buildIconButton(
                themeProvider,
                icon: FluentIcons.music_in_collection_fill,
                tooltip: 'Scan for music',
                onPressed: () => _trackProvider.scanForMusic(context, _channel),
                label: 'Scan',
              ),
            ),
//                    const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.00, 6.0, 0.0, 0),
              child: _buildIconButton(
                themeProvider,
                icon: FluentIcons.refresh,
                tooltip: 'Reload tracks',
                onPressed: _loadTracks,
                label: 'Reload',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(ThemeProvider themeProvider,
      {required IconData icon, required String tooltip, required VoidCallback onPressed, required String label}) {
    return Column(
      children: [
        Tooltip(
          message: tooltip,
          child: IconButton(
            icon: Icon(
              icon,
              size: themeProvider.iconSizeMedium,
              color: themeProvider.iconColour,
            ),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: themeProvider.fontColour, fontSize: themeProvider.fontSizeSmall),
        ),
      ],
    );
  }

  Widget _buildSearchBars() {
    return Row(
      children: [
        SizedBox(
          width: fixedFirstColumnWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.00, 0.0, 0.0, 8.0),
            child: TextBox(
              controller: _fileBrowserSearchController,
              placeholder: 'Search Label or Album',
              onChanged: (value) {
                setState(() {
                  _fileBrowserSearchQuery = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.00, 0.0, 0.0, 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: searchBoxWidth,
                  child: TextBox(
                    controller: _trackTableSearchController,
                    placeholder: 'Search Table search all or use column:search',
                    onChanged: (value) {
                      setState(() {
                        _trackTableSearchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(ThemeProvider themeProvider) {
    return Container(
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
    );
  }

  SplayTreeMap<String, Set<String>> _filterPublisherAlbums() {
    return PublisherFilter.filterPublisherAlbums(_publisherAlbums, _fileBrowserSearchQuery);
  }

  List<Track> _filterTracks() {
    return TrackFilter.filterTracks(_trackProviderState.tracks, _trackTableSearchQuery, _selectedPublishers, _selectedAlbums);
  }

  _buildBrowserAndTable(ThemeProvider themeProvider) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: fixedFirstColumnWidth,
            child: PublisherBrowser(
              publisherAlbums: _filterPublisherAlbums(),
              onPublishersSelected: (publishers) {
                setState(() {
                  _selectedPublishers.clear();
                  _selectedPublishers.addAll(publishers);
                });
              },
              onAlbumsSelected: (albums) {
                setState(() {
                  _selectedAlbums.clear();
                  _selectedAlbums.addAll(albums);
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: Align(
                alignment: Alignment.topCenter,
                child: TrackTable(
                  tracks: _filterTracks(),
                  scrollController: _scrollController,
                  onTrackSelected: (track) {
                    _logger.info('Track selected: ${track.id} : ${track.title}');
                    _mediaPlayer.loadTrack(track);
                  },
                  onTrackDeSelected: () {
                    _logger.info('Track de-selected');
                    _mediaPlayer.unloadTrack();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
