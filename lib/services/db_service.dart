import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../utils/endpoints.dart';

class DbService {
  Future<void> initDatabaseFactory() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  Future<String?> fetchActiveDatabase() async {
    String uri = Endpoints.getActiveDatabaseUri();
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      return json.decode(response.body)['name'];
    } else {
      print('Failed to fetch active database: ${response.body}');
      return null;
    }
  }

  Future<List<Map<String, String>>> loadDatabases() async {
    final prefs = await SharedPreferences.getInstance();
    final String? databasesString = prefs.getString('databases');
    if (databasesString != null) {
      return List<Map<String, String>>.from(json.decode(databasesString).map((item) => Map<String, String>.from(item)));
    }
    return [];
  }

  Future<void> saveDatabases(List<Map<String, String>> databases) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('databases', json.encode(databases));
  }

  Future<void> createDatabase(String dbName, String selectedDirectory) async {
    String dbPath = path.join(selectedDirectory, '$dbName.db');
    await openDatabase(dbPath);
  }

  Future<String?> pickDatabase() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select SQLite Database',
      type: FileType.custom,
      allowedExtensions: ['db'],
    );

    if (result != null && result.files.single.path != null) {
      return result.files.single.path!;
    }
    return null;
  }

  Future<String?> createDatabasePrompt() async {
      String? result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Database As',
        fileName: 'database.db', // Default file name
        type: FileType.custom,
        allowedExtensions: ['db'],
      );
  
      if (result != null) {
        return result;
      }
      return null;
    }

  Future<Map<String, dynamic>> initialise(String dbName, String dbPath) async {
    try {
      print('Initialising database: $dbName at $dbPath');
      final response = await http
          .post(
            Uri.parse(Endpoints.getInitialiseUri(dbName)),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'name': dbName, 'path': dbPath}),
          )
          .timeout(const Duration(seconds: 10), onTimeout: () {
            print('Request timed out');
            throw TimeoutException('The connection has timed out, please try again later.');
          });

      if (response.statusCode == 200) {
        return {'status': 'success', 'message': 'Database initialised successfully'};
      } else {
         print('status = error');
        return {
          'status': 'error',
          'message': 'Failed to initialise database: ${response.body}',
          'statusCode': response.statusCode,
        };
      }
    } catch (error) {
      if (error is TimeoutException) {
        print('Caught timeout exception');
        return {
          'status': 'error',
          'message': 'Request timed out',
          'statusCode': 408, // HTTP status code for request timeout
        };
      }
      print('Error initialising database: $error');
      return {
        'status': 'error',
        'message': 'Error initialising database: $error',
        'statusCode': 500, // HTTP status code for internal server error
      };
    }
  }
}
