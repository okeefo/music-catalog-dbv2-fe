import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/db_service.dart';
import '../utils/endpoints.dart';
import 'package:logging/logging.dart';

class DbProvider with ChangeNotifier {
  final DbService _dbService = DbService();
  final Logger _logger = Logger('DbProvider');
  List<Map<String, String>> databases = [];
  String? activeDatabase;

  DbProvider() {
    _initialize();
  }

  DbService get dbService => _dbService;

  Future<void> _initialize() async {
    try {
      await _dbService.initDatabaseFactory();
      databases = await _dbService.loadDatabases();
      activeDatabase = await _dbService.fetchActiveDatabase();
      notifyListeners();
      _logger.info('Initialization completed successfully');
    } catch (e) {
      _logger.severe('Error during initialization: $e');
      // Handle error appropriately
    }
  }

  Future<void> addDatabase(BuildContext context, String dbPath, String dbName) async {
    try {
      _logger.info('Attempting to add database: $dbName');
      //TODO: the initialise method shouw check the version number and if the DB is valid before adding it to the list
      final result = await _dbService.initialise(dbName, dbPath);

      if (result['status'] == 'success') {
        databases.add({'Path': dbPath, 'Name': dbName});
        await _dbService.saveDatabases(databases);
        notifyListeners();
        if (context.mounted) {
          _showPopup(context, 'Success', result['message']);
        }
      } else {
        if (context.mounted) {
          _showPopup(context, 'Error', '${result['message']} (Status code: ${result['statusCode']})');
        }
      }
    } catch (e) {
      _logger.severe('Error adding database: $e');
      if (context.mounted) {
        _showPopup(context, 'Error', 'Failed to add database: $e');
      }
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

  Future<void> removeDatabase(BuildContext context, int index) async {
    try {
      _logger.info('Attempting to remove database at index $index');
      databases.removeAt(index);
      await _dbService.saveDatabases(databases);
      notifyListeners();
      _logger.info('Database removed successfully');
    } catch (e) {
      _logger.severe('Error removing database: $e');
      if (context.mounted) {
        _showPopup(context, 'Error', 'Failed to remove database: $e');
      }
    }
  }

  Future<void> setActiveDatabase(BuildContext context, String dbName, String dbPath) async {
    try {

      _logger.info('Attempting to set active database: $dbName');

      final response = await http.post(
        Uri.parse(Endpoints.getActiveDatabaseUri()),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': dbName, 'path': dbPath}),
      );

      if (response.statusCode == 200) {
        activeDatabase = dbName;
        notifyListeners();
        _logger.info('Active database set successfully');
      } else {
        _logger.severe('Failed to set active database: ${response.body}');
        if (context.mounted) {
          _showPopup(context, 'Error', 'Failed to set active database: ${response.body} (Status code: ${response.statusCode})');
        }
      }
    } catch (e) {
      _logger.severe('Error setting active database: $e');
      if (context.mounted) {
        _showPopup(context, 'Error', 'Failed to set active database: $e');
      }
    }
  }
}
