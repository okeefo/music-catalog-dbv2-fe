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

  Future<void> addDatabase(BuildContext context,  String dbPath, String dbName) async {
    final result = await _dbService.initialise(dbName, dbPath);

    if (result['status'] == 'success') {
      databases.add({'Path': dbPath, 'Name': dbName});
      await _dbService.saveDatabases(databases);
      notifyListeners();
      _showPopup(context, 'Success', result['message']);
    } else {
      _showPopup(context, 'Error', '${result['message']} (Status code: ${result['statusCode']})');
    }
  }

  void _showPopup(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> removeDatabase(int index) async {
    databases.removeAt(index);
    await _dbService.saveDatabases(databases);
    notifyListeners();
  }

  Future<void> setActiveDatabase(String dbName, String dbPath) async {
    final response = await http.post(
      Uri.parse(Endpoints.getActiveDatabaseUri()),
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
