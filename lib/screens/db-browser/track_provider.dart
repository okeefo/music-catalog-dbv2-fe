import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/screens/popups.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'track_model.dart';
import '../../services/db_service.dart';
import 'package:logging/logging.dart';

class TrackProvider {
  static final Logger _logger = Logger('TrackService');

  static Future<TrackQueryResponse> fetchTracks(int offset, int limit) async {
    final dbService = DbService();
    final response = await dbService.getTracks(offset, limit);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return TrackQueryResponse.fromJson(data);
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  static Future<void> scanForMusic(BuildContext context, WebSocketChannel? channel) async {
    
    if (channel == null) {
      throw Exception('WebSocket channel is not initialized');
    }

    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) {
      return;
    }

    final dbService = DbService();
    final response = await dbService.scanForMusic(directoryPath);

    if (response.statusCode != 200) {
      if (!context.mounted) return; // Check if the context is still valid
       showErrorDialog(context, 'Failed to initiate scan: ${response.body}', 'Error');
      
    }
  }

  static Future<void> loadTracks({
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

  static Future<void> loadMoreTracks({
    required TrackProviderState state,
    required Function(List<Track>, int) onSuccess,
    required Function(String) onError,
  }) async {
    if (state.isLoading) {
      _logger.info("Still loading more tracks skipping");
      return;
    }

    if (state.offset >= state.totalTracks) {
      _logger.info("No more tracks to load offset: ${state.offset} total: ${state.totalTracks}");
      return;
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
}

class TrackProviderState {
  bool isLoading = false;
  int offset = 0;
  final int limit = 24;
  int totalTracks = 0;
  final List<Track> tracks = [];

  void setLoading(bool value) {
    isLoading = value;
  }

  void resetOffset() {
    offset = 0;
  }

  void incrementOffset() {
    offset += limit;
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
