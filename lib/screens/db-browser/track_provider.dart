import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/screens/popups.dart';
import 'package:front_end/services/media_services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'track_model.dart';
import '../../services/db_service.dart';
import 'package:logging/logging.dart';

class TrackProvider {
  // Private constructor
  TrackProvider._privateConstructor();

  // The single instance of the class
  static final TrackProvider _instance = TrackProvider._privateConstructor();

  // Factory constructor to return the same instance
  factory TrackProvider() {
    return _instance;
  }
  final DbService _dbService = DbService();
  final MediaService _mediaService = MediaService();

  static final Logger _logger = Logger('TrackProvider');

  Future<TrackQueryResponse> fetchTracks(int offset, int limit) async {
    final response = await _dbService.getTracks(offset, limit);
    if (response.statusCode == 200) {
      _logger.info('Got 200 response from Backend decoding response');
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return TrackQueryResponse.fromJson(data);
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  Future<void> scanForMusic(BuildContext context, WebSocketChannel? channel) async {
    if (channel == null) {
      throw Exception('WebSocket channel is not initialized');
    }

    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) {
      return;
    }

    final response = await _dbService.scanForMusic(directoryPath);

    if (response.statusCode != 200) {
      if (!context.mounted) return; // Check if the context is still valid
      showErrorDialog(context, 'Failed to initiate scan: ${response.body}', 'Error');
    }
  }

  Future<void> loadTracks({
    required TrackProviderState state,
    required Function(List<Track>, int) onSuccess,
    required Function(String) onError,
  }) async {
    _logger.info("loading tracks");
    state.setLoading(true);
    state.resetOffset();
    state.clearTracks();

    try {
      final trackQueryResponse = await fetchTracks(state.offset, state.limit);
      onSuccess(trackQueryResponse.tracks, trackQueryResponse.totalTracks);
      state.incrementOffset();
    } catch (e) {
      _logger.severe("Failed to fetch tracks: $e");
      onError(e.toString());
    } finally {
      state.setLoading(false);
    }
  }

  Future<void> loadMoreTracks({
    required TrackProviderState state,
    required Function(List<Track>, int) onSuccess,
    required Function(String) onError,
  }) async {
    if (state.isLoading) {
      _logger.info("Still loading more tracks skipping");
      return;
    }

    if (state.offset >= state.totalTracks) {
      await refreshTotalNumberOfTracks(state);
      if (state.offset >= state.totalTracks) {
        _logger.info("No more tracks to load offset: ${state.offset} total: ${state.totalTracks}");
        return;
      }
    }

    _logger.info("loading more tracks");
    state.setLoading(true);

    try {
      final trackQueryResponse = await fetchTracks(state.offset, state.limit);
      onSuccess(trackQueryResponse.tracks, trackQueryResponse.totalTracks);
      state.incrementOffset();
    } catch (e) {
      _logger.severe("Failed to fetch tracks: $e");
      onError(e.toString());
    } finally {
      state.setLoading(false);
    }
  }

  Future<void> refreshTotalNumberOfTracks(TrackProviderState state) async {
    final response = await _dbService.getTotalNumberOfTracks();
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      state.setTotalTracks(data['totalRecords']);
    } else {
      throw Exception('Failed to load total number of tracks');
    }
  }

  Future<void> playTrack(Track track, Function(String) onError) async {
    try {
      await _mediaService.playTrack(track);
    } catch (e) {
      onError('Failed to play track: ${track.title}\n\n${e.toString()}');
    }
  }

  Future<void> pauseTrack() async {
    await _mediaService.pauseTrack();
  }

  Future<void> stopTrack() async {
    await _mediaService.stopTrack();
  }

  Future<Uint8List> loadTrackArtwork(Track track) async {
    final response = await _mediaService.getTrackArtwork(track.id);
    if (response.statusCode == 200) {
      if (response.headers['content-type']?.startsWith('image/') ?? false) {
        return response.bodyBytes;
      } else {
        throw Exception('Invalid content type: ${response.headers['content-type']}');
      }
    } else {
      throw Exception('Failed to load track artwork');
    }
  }

  loadTrackWaveformData(Track track) async {
    _logger.info("Loading waveform data for track: ${track.id} - ${track.title}");
    final response = await _mediaService.getTrackWaveformData(track.id);
    if (response.statusCode == 200) {
      final rawList = jsonDecode(response.body) as List<dynamic>;
      return rawList.map((e) => (e as num).toDouble()).toList();
    } else {
      throw Exception('Failed to load track waveform data');
    }
  }

  loadTrackDuration(Track track) async {
    _logger.info("Loading duration for track: ${track.id} - ${track.title}");
    final response = await _mediaService.getTrackDuration(track.id);
    if (response.statusCode == 200) {
      final durationInNanoseconds = jsonDecode(utf8.decode(response.bodyBytes)) as int;
      // Convert nanoseconds to seconds
      return durationInNanoseconds /1e9 ;
    } else {
      throw Exception('Failed to load track duration');
    }
  }
  
  seekTo(Track track, value) async {
    _logger.info("Seek to point in time, $value for track: ${track.id} - ${track.title}");
    final response = await _mediaService.seekTo(track, value);
    if (response.statusCode == 200) {
      _logger.info("Successful - Seek to point in time, $value for track: ${track.id} - ${track.title}");
    } else {
      throw Exception('Failed to load track duration');
    }
  }
}

class TrackProviderState {
  bool isLoading = false;
  int offset = 0;
  final int limit = 1000;
  int totalTracks = 0;
  final List<Track> tracks = [];

  void setLoading(bool value) {
    isLoading = value;
  }

  void resetOffset() {
    offset = 0;
  }

//TODO: improve the state handling of offset and totalTracks
  void incrementOffset() {
    if (offset + limit > totalTracks) {
      offset = totalTracks;
    } else {
      offset += limit;
    }
  }

  void clearTracks() {
    tracks.clear();
  }

  void addTracks(List<Track> newTracks) {
    tracks.addAll(newTracks);
  }

  void setTotalTracks(int value) {
    totalTracks = value;
  }
}
