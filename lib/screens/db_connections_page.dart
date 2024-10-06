import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import '../providers/db_provider.dart';
import '../utils/app_styles.dart';

class DbConnectionsPage extends StatelessWidget {
  final Color fontColour;

  DbConnectionsPage({super.key, required this.fontColour});

  @override
  Widget build(BuildContext context) {
    final Color fontColor = fontColour;

    return ChangeNotifierProvider(
      create: (_) => DbProvider(),
      child: Consumer<DbProvider>(
        builder: (context, dbProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'DB Connections Page',
                  style: TextStyle(
                    fontSize: AppTheme.titleTextSize,
                    fontFamily: AppTheme.fontFamily,
                    color: fontColor,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Path', style: TextStyle(fontWeight: FontWeight.bold, color: fontColor)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, color: fontColor)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: fontColor)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Remove', style: TextStyle(fontWeight: FontWeight.bold, color: fontColor)),
                          ),
                        ],
                      ),
                      ...dbProvider.databases.map((db) {
                        int index = dbProvider.databases.indexOf(db);
                        bool isConnected = db['Name'] == dbProvider.activeDatabase;
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(db['Path']!, style: TextStyle(color: fontColor)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(db['Name']!, style: TextStyle(color: fontColor)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tooltip(
                                message: 'Click to ${isConnected ? 'Deactivate' : 'Activate'}',
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!isConnected) {
                                      await dbProvider.setActiveDatabase(context, db['Name']!, db['Path']!);
                                    }
                                  },
                                  child: Icon(
                                    isConnected ? FluentIcons.check_mark : FluentIcons.cancel,
                                    color: isConnected ? Colors.green : Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(FluentIcons.delete),
                                    onPressed: () => dbProvider.removeDatabase(context, index),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(FluentIcons.add),
                          onPressed: () async {
                            String? dbPath = await dbProvider.dbService.pickDatabase();
                            if (dbPath != null) {
                              String dbName = path.basenameWithoutExtension(dbPath);
                              await dbProvider.addDatabase(context, dbPath, dbName);
                            }
                          },
                        ),
                        const SizedBox(height: 4),
                        const Text('Add'),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(FluentIcons.database),
                          onPressed: () async {
                            String? selectedDirectory = await dbProvider.dbService.createDatabasePrompt();
                            if (selectedDirectory != null) {
                              String dbName = path.basename(selectedDirectory);
                              await dbProvider.addDatabase(context, selectedDirectory, dbName);
                            }
                          },
                        ),
                        const SizedBox(height: 4),
                        const Text('Create DB'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}