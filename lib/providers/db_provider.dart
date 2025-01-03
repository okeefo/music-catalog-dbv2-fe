import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/db_service.dart';
import '../utils/endpoints.dart';
import '../providers/theme_provider.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class DbProvider with ChangeNotifier {
  final DbService _dbService = DbService();
  final Logger _logger = Logger('DbProvider');
  List<Map<String, String>> databases = [];
  String? activeDatabase;

  DbProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
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
      _logger.info("Attempting to add database: name='$dbName' path='$dbPath'");

      final result = await _dbService.createDatabase(dbName, dbPath);

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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeProvider.backgroundColour.withAlpha((1 * 255).toInt()),
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
      String uri = Endpoints.getActiveDatabaseUri();
      _logger.info('Attempting to set active database: $dbName : $uri');

      final response = await http.post(
        Uri.parse(uri),
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

  Future<String?> pickDatabase() async {
    return _dbService.pickDatabase();
  }

  Future<String?> createDatabasePrompt() async {
    return _dbService.createDatabasePrompt();
  }
}
