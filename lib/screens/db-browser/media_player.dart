import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:front_end/screens/db-browser/track_model.dart';
import 'package:front_end/screens/db-browser/track_provider.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class MediaPlayer extends StatefulWidget {
  const MediaPlayer({required GlobalKey<MediaPlayerState> key}) : super(key: key);
  MediaPlayerState? get _playerState => (key as GlobalKey<MediaPlayerState>).currentState;

  static final Logger _logger = Logger('MediaPlayer');

  @override
  MediaPlayerState createState() => MediaPlayerState();

  void play() {
    _playerState?._play();
  }

  void pause() {
    _playerState?._pause();
  }

  void stop() {
    _playerState?._stop();
  }

  void loadTrack(Track track) {
    _logger.info("Loading track: ${track.id}: ${track.title}");
    _playerState?._loadTrack(track);
  }

  void unloadTrack() {
    _playerState?.unloadTrack();
  }
}

class MediaPlayerState extends State<MediaPlayer> {
  static final Logger _logger = Logger('MediaPlayerState');
  static final spacer = const SizedBox(width: 16);
  static final TrackProvider _trackProvider = TrackProvider();
  static final AssetImage defaultArtwork = AssetImage('assets/vinyl-100.png');

  Track? _currentTrack;
  Uint8List? _currentArtwork;
  Uint8List? _currentWaveform;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600), // Set a maximum width constraint
      child: SizedBox(
        height: 120.0, // Reduced height to better fit the layout
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildArtwork(), _buildMedialButtons()],
            ),
            spacer,
            Expanded(
              child: Container(
                height: double.infinity,
                color: themeProvider.greyBackground,
                child: _currentWaveform == null
                    ? Center(
                      child: Text(
                          'No Track Selected / Loaded',
                          style: TextStyle(
                            color: themeProvider.fontColour,
                            fontSize: themeProvider.fontSizeLarge,
                          ), // Ensure color is not null
                        ),
                    )
                    : Image.memory(
                        _currentWaveform!,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          _logger.severe('Error displaying waveform: $error$stackTrace');
                          return Text(
                            'Error loading waveform',
                            style: TextStyle(
                              color: themeProvider.fontColour,
                              fontSize: themeProvider.fontSizeLarge,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildMedialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _createButton(FluentIcons.play, _play),
        _createButton(FluentIcons.pause, _pause),
        _createButton(FluentIcons.stop, _stop),
      ],
    );
  }

  void _play() {
    _logger.info("Play button pressed");
    if (_currentTrack != null) {
      _trackProvider.playTrack(_currentTrack!, (error) {
        _logger.severe("Failed to play track: $error");
      });
    }
  }

  void _pause() {
    _logger.info("Pause button pressed");
    _trackProvider.pauseTrack();
  }

  void _stop() {
    _logger.info("Stop button pressed");
    _trackProvider.stopTrack();
  }

  void _loadTrack(Track track) {
    _logger.info("(state) Loading track: ${track.id}: ${track.title}");
    setState(() {
      _currentTrack = track;
    });
    _loadArtwork(track);
    _loadWaveform(track);
  }

  void _loadArtwork(Track track) {
    _trackProvider.loadTrackArtwork(track).then((artwork) {
      setState(() {
        _currentArtwork = artwork;
      });
    }).catchError((error) {
      _logger.severe("Failed to load artwork: $error");
      setState(() {
        _currentArtwork = null;
      });
    });
  }

  void unloadTrack() {
    _logger.info("Unloading track");
    setState(() {
      _currentTrack = null;
      _currentArtwork = null;
      _currentWaveform = null;
    });
  }

  Widget _createButton(IconData icon, Function() action) {
    return IconButton(
      icon: Icon(icon),
      onPressed: action,
    );
  }

  Widget _buildArtwork() {
    if (_currentArtwork == null) {
      return _buildDefaultArtwork();
    } else {
      return GestureDetector(
        onDoubleTap: () {
          _showFullSizeArtwork(context, _currentArtwork!);
        },
        child: Container(
          width: 94.0,
          height: 94.0,
          color: Colors.white,
          child: Center(
            child: Image.memory(
              _currentArtwork!,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                _logger.severe('Error displaying artwork: $error$stackTrace');
                return _buildDefaultArtwork();
              },
            ),
          ),
        ),
      );
    }
  }

  Widget _buildDefaultArtwork() {
    return ClipOval(
      child: Container(
        width: 94.0, // Reduced width to better fit the layout
        height: 94.0,
        color: Colors.white,
        child: Center(
          child: Image(
            image: defaultArtwork,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  void _showFullSizeArtwork(BuildContext context, Uint8List artwork) {
    // Show the dialog with the calculated dimensions
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ContentDialog(
          title: Text('Artwork'),
          constraints: BoxConstraints(maxWidth: 600, maxHeight: 900),
          content: Image.memory(
            artwork,
            fit: BoxFit.fill,
          ),
          actions: [
            Button(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void _loadWaveform(Track track) {
    _trackProvider.loadTrackWaveform(track).then((waveform) {
      setState(() {
        _currentWaveform = waveform;
      });
    }).catchError((error) {
      _logger.severe("Failed to load waveform: $error");
      setState(() {
        _currentWaveform = null;
      });
    });
  }
}
