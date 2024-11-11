import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:front_end/screens/db-browser/filters.dart';
import 'package:provider/provider.dart';
import '../../providers/db_provider.dart';
import 'track_table.dart';
import 'track_service.dart';
import 'track_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:logging/logging.dart';

//TODO: BugFix - infinte scrolling
//TODO: Imporvement - when clicking to another page - table - re-renders
//TODO: BugFix - missing tack data on some tracks but the data is there
//TODO: improve styling
//TODO: Show the hyperlink address when hovering over the Release Id cell
//TODO: Hide the ID column replace with row number
//TODO: replace MP3/WAV/FLAC with icons
//TODO: Do add total number of records summary
//TODO: Hide file location and hyper link from title cell
//TODO: Add a filter to show only MP3/WAV/FLAC
//TODO: Add album art
//TODO: add column show/hide selector
//TODO: Add column sort
//TODO: Add a search bar
//TODO: add a tree view to list by artist/album/label
//TODO: When selecting a folder in the treeview show the tracks in the main view
//TODO: Add a stereo bar to load tracks, show progress, with a playlist button
//TODO: Show wave file in stereo bar - and be able to click on it to jump to that part of the track
//TODO: Add volume control to stereo bar
//TODO: Add a stop button to stereo bar
//TODO: Add a pause button to stereo bar
//TODO: Add a next track button to stereo bar


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
  final List<Track> _tracks = [];
  final ScrollController _scrollController = ScrollController();
  final Logger _logger = Logger('DbBrowserPageState');

  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 30;

  @override
  void initState() {
    _logger.info("initstate"  );
    super.initState();
    _loadTracks();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
        _loadMoreTracks();
      }
    });
  }

  @override
  void dispose() {
    _channel?.sink.close(status.goingAway);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTracks() async {
    _logger.info("loading tracks"  );
    setState(() {
      _isLoading = true;
      _offset = 0;
      _tracks.clear();
    });

    try {
      final newTracks = await TrackService.fetchTracks(_offset, _limit);
      _logger.info("loaded ${newTracks.length} tracks"  );
      setState(() {
        _tracks.addAll(newTracks);
        _offset += _limit;
      });

    } catch (e) {
      _logger.severe("Failed to fetch tracks: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreTracks() async {
    if (_isLoading) return;
    _logger.info("loading more tracks"  );

    setState(() {
      _isLoading = true;
    });

    try {
      final newTracks = await TrackService.fetchTracks(_offset, _limit);
      _logger.info("loaded ${newTracks.length} more tracks"  );
      setState(() {
        _tracks.addAll(newTracks);
        _offset += _limit;
      });
    } catch (e) {
      _logger.severe("Failed to fetch tracks: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                          onPressed: () => TrackService.scanForMusic(context, _statusUpdates, _channel),
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
                        tracks: _tracks,
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
        child: Text(
          _statusUpdates.isNotEmpty ? _statusUpdates.last : 'No updates yet',
          style: TextStyle(
            color: themeProvider.fontColour,
          ),
        ),
      ),
    );
  }
}
