import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../providers/db_provider.dart';

class DbBrowserPage extends StatelessWidget {
  const DbBrowserPage({
    super.key,
  });

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
              child: Consumer<DbProvider>(
                builder: (context, dbProvider, child) {
                  if (dbProvider.databases.isEmpty) {
                    return const CircularProgressIndicator();
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