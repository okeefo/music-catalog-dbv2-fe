import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/db_service.dart';
import '../utils/endpoints.dart' ;


class DbProvider with ChangeNotifier {
  final DbService _dbService = DbService();
  List<Map<String, String>> databases = [];
  String? activeDatabase;

  DbProvider() {
    _initialize();
  }

  DbService get dbService => _dbService;

  Future<void> _initialize() async {
    await _dbService.initDatabaseFactory();
    databases = await _dbService.loadDatabases();
    activeDatabase = await _dbService.fetchActiveDatabase();
    notifyListeners();
  }

  Future<void> addDatabase(String dbPath) async {
    String dbName = path.basenameWithoutExtension(dbPath);
    databases.add({'Path': dbPath, 'Name': dbName});
    await _dbService.saveDatabases(databases);
    notifyListeners();
  }

  Future<void> createDatabase(String dbName, String selectedDirectory) async {
    await _dbService.createDatabase(dbName, selectedDirectory);
    databases.add({'Path': path.join(selectedDirectory, '$dbName.db'), 'Name': dbName});
    await _dbService.saveDatabases(databases);
    notifyListeners();
  }

  Future<void> removeDatabase(int index) async {
    databases.removeAt(index);
    await _dbService.saveDatabases(databases);
    notifyListeners();
  }

  Future<void> setActiveDatabase(String dbName, String dbPath) async {
    final response = await http.post(
      Uri.parse(Endpoints.activeDatabaseUri),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': dbName, 'path': dbPath}),
    );

    if (response.statusCode == 200) {
      activeDatabase = dbName;
      notifyListeners();
    } else {
      //print response.body and response.statusCode here
      print('Failed to set active database: ${response.body}');
    }
  }
}
