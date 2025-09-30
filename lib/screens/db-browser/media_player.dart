import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:front_end/screens/db-browser/track_model.dart';
import 'package:front_end/screens/db-browser/track_provider.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:front_end/screens/db-browser/waveform_painter.dart';
import 'package:audioplayers/audioplayers.dart';

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

enum PlayerStatus {
  playing,
  paused,
  stopped,
}

class MediaPlayerState extends State<MediaPlayer> {
  static final Logger _logger = Logger('MediaPlayerState');
  static final spacer = const SizedBox(width: 16);
  static final TrackProvider _trackProvider = TrackProvider();
  static final AssetImage defaultArtwork = AssetImage('assets/vinyl-100.png');

  final AudioPlayer _audioPlayer = AudioPlayer();
  Track? _currentTrack;
  Uint8List? _currentArtwork;
  List<double>? _waveformData;
  double _playbackProgress = 0.0;
  PlayerStatus _playerStatus = PlayerStatus.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isInteractingWithSlider = false;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        if (!_isInteractingWithSlider) {
          final int milliseconds = position.inMilliseconds;
          final int roundedMilliseconds = (milliseconds / 100).round() * 100; // Round to nearest 100ms
          _position = Duration(milliseconds: roundedMilliseconds);
          _playbackProgress = _position.inMilliseconds / (_duration.inMilliseconds == 0 ? 1 : _duration.inMilliseconds);
        }
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _play() async {
    _logger.info("Play button pressed");
    if (_currentTrack != null) {
      setState(() {
        _playerStatus = PlayerStatus.playing;
      });
      await _audioPlayer.setSourceDeviceFile(_currentTrack!.fileLocation);
      _audioPlayer.resume();
      //await _audioPlayer.play(_currentTrack!.fileLocation);
    }
  }

  void _pause() async {
    _logger.info("Pause button pressed");

    if (_playerStatus == PlayerStatus.playing) {
      setState(() {
        _playerStatus = PlayerStatus.paused;
      });
      await _audioPlayer.pause();
    } else if (_playerStatus == PlayerStatus.paused) {
      setState(() {
        _playerStatus = PlayerStatus.playing;
      });
      await _audioPlayer.resume();
    }
  }

  void _stop() async {
    _logger.info("Stop button pressed");
    setState(() {
      _playerStatus = PlayerStatus.stopped;
      _position = Duration.zero;
      _playbackProgress = 0.0;
    });
    await _audioPlayer.stop();
  }

  void _loadTrack(Track track) async {
    _logger.info("(state) Loading track: ${track.id}: ${track.title}");
    setState(() {
      _currentTrack = track;
      _position = Duration.zero;
    });

    // Check if the track is a local file or a URL
    if (track.fileLocation.startsWith('http') || track.fileLocation.startsWith('https')) {
      await _audioPlayer.setSourceUrl(track.fileLocation);
    } else {
      await _audioPlayer.setSourceDeviceFile(track.fileLocation);
    }

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
      _waveformData = null;
      _duration = Duration.zero;
      _position = Duration.zero;
    });
    _audioPlayer.stop();
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
    _trackProvider.loadTrackWaveformData(track).then((data) {
      setState(() {
        _waveformData = data; // data is a List<double> from backend
      });
    }).catchError((error) {
      _logger.severe("Failed to load waveform: $error");
      setState(() {
        _waveformData = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: SizedBox(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildArtwork(),
                _buildMedialButtons(),
              ],
            ),
            spacer,
            Expanded(
              child: Column(
                children: [
                  // Player status area
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Row(
                      children: [
                        // Show duration if we have a track
                        if (_currentTrack != null)
                          Text(
                            formatPlayPosition(_position.inMilliseconds),
                            style: TextStyle(
                              color: themeProvider.fontColour,
                              fontSize: themeProvider.fontSizeReg,
                            ),
                          ),
                        // Center the status details
                        Expanded(
                          child: Center(
                            child: Text(
                              _currentTrack == null
                                  ? "No track info"
                                  : _playerStatus == PlayerStatus.paused
                                      ? "** Paused **  : ${_currentTrack!.title}"
                                      : _currentTrack!.title,
                              style: TextStyle(
                                color: themeProvider.fontColour,
                                fontSize: themeProvider.fontSizeReg,
                              ),
                            ),
                          ),
                        ),
                        if (_currentTrack != null)
                          Text(
                            formatPlayPosition(_duration.inMilliseconds),
                            style: TextStyle(
                              color: themeProvider.fontColour,
                              fontSize: themeProvider.fontSizeReg,
                            ),
                          )
                      ],
                    ),
                  ),

                  // Waveform area
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                    height: 100.0,
                    child: _waveformData == null
                        ? Center(
                            child: Text(
                              'No Track Selected / Loaded',
                              style: TextStyle(
                                color: themeProvider.fontColour,
                                fontSize: themeProvider.fontSizeLarge,
                              ),
                            ),
                          )
                        : CustomPaint(
                            size: Size(double.infinity, 60),
                            painter: WaveformPainter(
                              waveformData: _waveformData!,
                              playbackProgress: _playbackProgress,
                              waveformColor: themeProvider.waveformColour,
                              progressColor: themeProvider.waveformProgressColour,
                              progressBarColor: themeProvider.waveformProgressBarColour,
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Slider(
                      style: SliderThemeData(
                        useThumbBall: true,
                        thumbRadius: WidgetStateProperty.all(12.00),
                        activeColor: WidgetStateProperty.all(const Color.fromARGB(255, 67, 52, 235)),
                        inactiveColor: WidgetStateProperty.all(const Color.fromARGB(255, 105, 156, 12)),
                        thumbBallInnerFactor: WidgetStateProperty.fromMap({WidgetState.pressed: 0.8, WidgetState.hovered: 0.65}),
                      ),
                      value: _position.inMilliseconds.toDouble() / 1000,
                      autofocus: false,
                      min: 0,
                      max: _duration.inMilliseconds.toDouble() / 1000,
                      onChangeStart: (value) {
                        _isInteractingWithSlider = true;
                      },
                      onChanged: (value) {
                        setState(() {
                          _position = Duration(seconds: value.toInt());
                          _playbackProgress = _position.inSeconds / (_duration.inSeconds == 0 ? 1 : _duration.inSeconds);
                        });
                      },
                      onChangeEnd: (value) {
                        setState(() {
                          _isInteractingWithSlider = false;
                        });
                        _audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                ],
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
        _createButton(
          _playerStatus == PlayerStatus.paused ? FluentIcons.play_resume : FluentIcons.pause,
          _pause,
        ),
        _createButton(FluentIcons.stop, _stop),
      ],
    );
  }
}

String formatPlayPosition(int milliseconds) {
  int hours = milliseconds ~/ 3600000;
  int minutes = (milliseconds % 3600000) ~/ 60000;
  int seconds = (milliseconds % 60000) ~/ 1000;
  int millis = (milliseconds % 1000) ~/ 100;

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(1, '0')}';
  } else {
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(1, '0')}';
  }
}
