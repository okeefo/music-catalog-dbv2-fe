import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../providers/db_provider.dart';
import '../utils/app_styles.dart';

class DbConnectionsPage extends StatelessWidget {
  final Color darkFontColor;
  final Color lightFontColor;

  DbConnectionsPage({super.key, required this.darkFontColor, required this.lightFontColor});

  @override
  Widget build(BuildContext context) {
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
                    color: FluentTheme.of(context).brightness == Brightness.dark ? darkFontColor : lightFontColor,
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
                      const TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Path', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Remove', style: TextStyle(fontWeight: FontWeight.bold)),
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
                              child: Text(db['Path']!),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(db['Name']!),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tooltip(
                                message: 'Click to ${isConnected ? 'Deactivate' : 'Activate'}',
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!isConnected) {
                                      await dbProvider.setActiveDatabase(db['Name']!, db['Path']!);
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
                                    onPressed: () => dbProvider.removeDatabase(index),
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
                              await dbProvider.addDatabase(dbPath);
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
                            String? selectedDirectory = await dbProvider.dbService.pickDirectory();
                            if (selectedDirectory != null) {
                              TextEditingController nameController = TextEditingController();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ContentDialog(
                                    title: const Text('Create Database'),
                                    content: SizedBox(
                                      width: 300,
                                      child: TextBox(
                                        controller: nameController,
                                        placeholder: 'Enter database name',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    actions: [
                                      Button(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      Button(
                                        child: const Text('Create'),
                                        onPressed: () async {
                                          String dbName = nameController.text;
                                          if (dbName.isNotEmpty) {
                                            await dbProvider.createDatabase(dbName, selectedDirectory);
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
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
