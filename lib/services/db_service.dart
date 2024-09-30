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
    String uri = Endpoints.activeDatabaseUri;
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

  Future<String?> pickDirectory() async {
    return await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select Folder for Database');
  }
}
