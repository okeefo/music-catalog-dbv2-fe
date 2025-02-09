import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:front_end/screens/db-browser/track_model.dart';
import 'package:front_end/screens/db-browser/track_provider.dart';

class MediaPlayerProvider extends ChangeNotifier {
  static final Logger _logger = Logger('MediaPlayerProvider');
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TrackProvider _trackProvider = TrackProvider();

  Track? _currentTrack;
  Uint8List? _currentArtwork;
  List<double>? _waveformData;
  double _playbackProgress = 0.0;
  PlayerStatus _playerStatus = PlayerStatus.Stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isInteractingWithSlider = false;

  Track? get currentTrack => _currentTrack;
  Uint8List? get currentArtwork => _currentArtwork;
  List<double>? get waveformData => _waveformData;
  double get playbackProgress => _playbackProgress;
  PlayerStatus get playerStatus => _playerStatus;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get isInteractingWithSlider => _isInteractingWithSlider;

  MediaPlayerProvider() {
    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (!_isInteractingWithSlider) {
        final int milliseconds = position.inMilliseconds;
        final int roundedMilliseconds = (milliseconds / 100).round() * 100; // Round to nearest 100ms
        _position = Duration(milliseconds: roundedMilliseconds);
        _playbackProgress = _position.inMilliseconds / (_duration.inMilliseconds == 0 ? 1 : _duration.inMilliseconds);
        notifyListeners();
      }
    });
  }

  Future<void> play() async {
    _logger.info("Play button pressed");
    if (_currentTrack != null) {
      _playerStatus = PlayerStatus.Playing;
      notifyListeners();
      await _audioPlayer.setSourceDeviceFile(_currentTrack!.fileLocation);
      _audioPlayer.resume();
    }
  }

  Future<void> pause() async {
    _logger.info("Pause button pressed");

    if (_playerStatus == PlayerStatus.Playing) {
      _playerStatus = PlayerStatus.Paused;
      notifyListeners();
      await _audioPlayer.pause();
    } else if (_playerStatus == PlayerStatus.Paused) {
      _playerStatus = PlayerStatus.Playing;
      notifyListeners();
      await _audioPlayer.resume();
    }
  }

  Future<void> stop() async {
    _logger.info("Stop button pressed");
    _playerStatus = PlayerStatus.Stopped;
    _position = Duration.zero;
    _playbackProgress = 0.0;
    notifyListeners();
    await _audioPlayer.stop();
  }

  void seekTo(Duration position) {
    _logger.info("Seeking to: ${position.inSeconds}");
    _audioPlayer.seek(position);
  }

  Future<void> loadTrack(Track track) async {
    _logger.info("Loading track: ${track.id}: ${track.title}");
    _currentTrack = track;
    _position = Duration.zero;
    notifyListeners();

    // Check if the track is a local file or a URL
    if (track.fileLocation.startsWith('http') || track.fileLocation.startsWith('https')) {
      await _audioPlayer.setSourceUrl(track.fileLocation);
    } else {
      await _audioPlayer.setSourceDeviceFile(track.fileLocation);
    }

    _loadArtwork(track);
    _loadWaveform(track);
  }

  Future<void> unloadTrack() async {
    _logger.info("Unloading track");

    _currentTrack = null;
    _currentArtwork = null;
    _waveformData = null;
    _duration = Duration.zero;
    _position = Duration.zero;
    _audioPlayer.stop();
    notifyListeners();
  }

  Future<void> _loadArtwork(Track track) async {
    try {
      _currentArtwork = await _trackProvider.loadTrackArtwork(track);
    } catch (error) {
      _logger.severe("Failed to load artwork: $error");
      _currentArtwork = null;
    }
    notifyListeners();
  }

  Future<void> _loadWaveform(Track track) async {
    try {
      _waveformData = await _trackProvider.loadTrackWaveformData(track);
    } catch (error) {
      _logger.severe("Failed to load waveform: $error");
      _waveformData = null;
    }
    notifyListeners();
  }

  void setInteractingWithSlider(bool value) {
    _isInteractingWithSlider = value;
    notifyListeners();
  }

  void updatePosition(double value) {
    _position = Duration(seconds: value.toInt());
    _playbackProgress = _position.inSeconds / (_duration.inSeconds == 0 ? 1 : _duration.inSeconds);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

enum PlayerStatus {
  Playing,
  Paused,
  Stopped,
}
