import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../utils/endpoints.dart';
import 'package:logging/logging.dart';

class DbService {
  final Logger _logger = Logger('DbService');

  Future<void> initDatabaseFactory() async {
    try {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      _logger.info('Database factory initialized successfully');
    } catch (e) {
      _logger.severe('Error initializing database factory: $e');
      // Handle error appropriately
    }
  }

  Future<String?> fetchActiveDatabase() async {
    try {
      String uri = Endpoints.getActiveDatabaseUri();
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        _logger.info('Active database fetched successfully');
        return json.decode(response.body)['name'];
      } else {
        _logger.severe('Failed to fetch active database: ${response.body}');
        return null;
      }
    } catch (e) {
      _logger.severe('Error fetching active database: $e');
      return null;
    }
  }

  Future<List<Map<String, String>>> loadDatabases() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? databasesString = prefs.getString('databases');
      if (databasesString != null) {
        _logger.info('Databases loaded successfully');
        return List<Map<String, String>>.from(json.decode(databasesString).map((item) => Map<String, String>.from(item)));
      }
      return [];
    } catch (e) {
      _logger.severe('Error loading databases: $e');
      return [];
    }
  }

  Future<void> saveDatabases(List<Map<String, String>> databases) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('databases', json.encode(databases));
      _logger.info('Databases saved successfully');
    } catch (e) {
      _logger.severe('Error saving databases: $e');
      // Handle error appropriately
    }
  }

  Future<String?> pickDatabase() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select SQLite Database',
        type: FileType.custom,
        allowedExtensions: ['db'],
      );

      if (result != null && result.files.single.path != null) {
        _logger.info('Database selected: ${result.files.single.path!}');
        return result.files.single.path!;
      }
    } catch (e) {
      _logger.severe('Error picking database: $e');
      // Handle error appropriately
    }
    return null;
  }

  Future<String?> createDatabasePrompt() async {
    try {
      _logger.info('Creating database.. prompt user');
      String? result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Database As',
        fileName: 'myMusicKillerDatabase.db', // Default file name
        type: FileType.custom,
        allowedExtensions: ['db'],
      );

      if (result != null) {
        //if doesn't end with the file extension .db then add it
        if (!result.endsWith('.db')) {
          result = '$result.db';
        }
        _logger.info('Database save path selected: $result');
        return result;
      }
    } catch (e) {
      _logger.severe('Error creating database prompt: $e');
      // Handle error appropriately
    }
    return null;
  }

  Future<Map<String, dynamic>> createDatabase(String dbName, String dbPath) async {
    try {
      Uri uri = Uri.parse(Endpoints.postCreateDataBaseUri());
      _logger.info('Calling backed to create database: $uri');
      final response = await http
          .post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': dbName, 'path': dbPath}),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        _logger.warning('Request timed out');
        throw TimeoutException('The connection has timed out, please try again later.');
      });

      if (response.statusCode == 200) {
        _logger.info('Database initialised successfully');
        return {'status': 'success', 'message': 'Database initialised successfully'};
      } else {
        _logger.severe('Failed to initialise database: ${response.body}');
        return {
          'status': 'error',
          'message': 'Failed to initialise database: ${response.body}',
          'statusCode': response.statusCode,
        };
      }
    } catch (error) {
      if (error is TimeoutException) {
        _logger.warning('Caught timeout exception');
        return {
          'status': 'error',
          'message': 'Request timed out',
          'statusCode': 408, // HTTP status code for request timeout
        };
      }
      _logger.severe('Error initialising database: $error');
      return {
        'status': 'error',
        'message': 'Error initialising database: $error',
        'statusCode': 500, // HTTP status code for internal server error
      };
    }
  }

  Future<http.Response> scanForMusic(String directoryPath) async {
    Uri uri = Uri.parse(Endpoints.scanForMusicUri());
    String body = jsonEncode({'path': directoryPath});

    _logger.info('CAlling backend to scan for music files: $uri, $body');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      _logger.info('Music file scan adn DB updated successfully initiated');
    } else {
      _logger.severe('Failed to initiate scan for music files: ${response.body}');
    }
    return response;
  }
}
