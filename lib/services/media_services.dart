import 'dart:async';
import 'dart:convert';
import 'package:front_end/screens/db-browser/track_model.dart';
import 'package:http/http.dart' as http;
import '../utils/endpoints.dart';
import 'package:logging/logging.dart';

class MediaService {
  // Private constructor
  MediaService._privateConstructor();

  // The single instance of the class
  static final MediaService _instance = MediaService._privateConstructor();

  // Factory constructor to return the same instance
  factory MediaService() {
    return _instance;
  }

  static final Logger _logger = Logger('MediaService');

  Future<http.Response> playTrack(Track track) async {
    Uri uri = Uri.parse(Endpoints.playMediaUri());
    _logger.info('Calling backend to play track: ${track.id}, ${track.title}, uri: $uri');
    String body = jsonEncode({'trackId': track.id});

    final stopwatch = Stopwatch()..start();
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    stopwatch.stop();
    if (response.statusCode == 200) {
      _logger.info('play track request took: ${stopwatch.elapsedMilliseconds}ms');
      return response;
    } else {
      _logger.severe('Failed to request to play track: ${response.body} operation took ${stopwatch.elapsedMilliseconds}ms');
      throw Exception(response.body);
    }
  }

  Future<http.Response> pauseTrack() async {
    Uri uri = Uri.parse(Endpoints.pauseMediaUri());
    _logger.info('Calling backend to pause track: $uri');
    final stopwatch = Stopwatch()..start();
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    stopwatch.stop();
    if (response.statusCode == 200) {
      _logger.info('pause track request took: ${stopwatch.elapsedMilliseconds}ms');
      return response;
    } else {
      _logger.severe('Failed to request to pause track: ${response.body} operation took ${stopwatch.elapsedMilliseconds}ms');
      throw Exception('Failed to pause track');
    }
  }

  Future<http.Response> stopTrack() async {
    Uri uri = Uri.parse(Endpoints.stopMediaUri());
    _logger.info('Calling backend to stop track: $uri');
    final stopwatch = Stopwatch()..start();
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    stopwatch.stop();
    if (response.statusCode == 200) {
      _logger.info('stop track request took: ${stopwatch.elapsedMilliseconds}ms');
      return response;
    } else {
      _logger.severe('Failed to request to stop track: ${response.body} operation took ${stopwatch.elapsedMilliseconds}ms');
      throw Exception('Failed to stop track');
    }
  }
}
