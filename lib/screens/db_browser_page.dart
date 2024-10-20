import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/db_provider.dart';
import '../utils/endpoints.dart';
import '../services/db_service.dart';

class DbBrowserPage extends StatelessWidget {
  const DbBrowserPage({
    super.key,
  });

  Future<void> _scanForMusic(BuildContext context) async {
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      // Make a REST call to the backend to perform the scan
      final dbService = DbService();
      final response = await dbService.scanForMusic(directoryPath);

      if (response.statusCode == 200) {
        // Handle success
        showDialog(
          context: context,
          builder: (context) => ContentDialog(
            title: const Text('Scan Complete'),
            content: const Text('The music files have been successfully scanned and added to the database.'),
            actions: [
              Button(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      } else {
        // Handle error
        showDialog(
          context: context,
          builder: (context) => ContentDialog(
            title: const Text('Error'),
            content: Text('Failed to scan music files: ${response.body}'),
            actions: [
              Button(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScaffoldPage(
      header: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Consumer<DbProvider>(
                    builder: (context, dbProvider, child) {
                      if (dbProvider.databases.isEmpty) {
                        return const ProgressRing();
                      } else {
                        return ComboBox<String>(
                          items: dbProvider.databases.map((db) {
                            return ComboBoxItem<String>(
                              value: db['Name'],
                              child: Text(db['Name']!),
                            );
                          }).toList(),
                          value: dbProvider.activeDatabase,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              final selectedDb = dbProvider.databases.firstWhere(
                                (db) => db['Name'] == newValue,
                              );
                              dbProvider.setActiveDatabase(
                                context,
                                selectedDb['Name']!,
                                selectedDb['Path']!,
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      Tooltip(
                        message: 'Scan for music',
                        child: IconButton(
                          icon: const Icon(FluentIcons.music_in_collection_fill),
                          onPressed: () => _scanForMusic(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Scan',
                        style: TextStyle(
                          color: themeProvider.fontColour,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'DB Browser',
                style: TextStyle(
                  fontSize: 24,
                  color: themeProvider.fontColour,
                ),
              ),
            ),
          ],
        ),
      ),
      content: Center(
        child: Text(
          'DB Browser Content',
          style: TextStyle(
            color: themeProvider.fontColour,
          ),
        ),
      ),
    );
  }
}