import 'package:fluent_ui/fluent_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../utils/app_styles.dart';

class DbConnectionsPage extends StatefulWidget {
  final Color darkFontColor;
  final Color lightFontColor;

  DbConnectionsPage({super.key, required this.darkFontColor, required this.lightFontColor});

  @override
  _DbConnectionsPageState createState() => _DbConnectionsPageState();
}

class _DbConnectionsPageState extends State<DbConnectionsPage> {
  List<Map<String, String>> databases = [];

  @override
  void initState() {
    super.initState();
    // Initialize the database factory for sqflite_common_ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  Future<void> _createDatabase() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select Folder for Database');
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
                    String dbPath = path.join(selectedDirectory, '$dbName.db');
                    await openDatabase(dbPath);
                    setState(() {
                      databases.add({'Path': dbPath, 'Name': dbName});
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _addDatabase() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select SQLite Database',
      type: FileType.custom,
      allowedExtensions: ['db'],
    );

    if (result != null && result.files.single.path != null) {
      String dbPath = result.files.single.path!;
      String dbName = path.basenameWithoutExtension(dbPath);
      setState(() {
        databases.add({'Path': dbPath, 'Name': dbName});
      });
    }
  }

  void _removeDatabase(int index) {
    setState(() {
      databases.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'DB Connections Page',
            style: TextStyle(
              fontSize: AppTheme.titleTextSize, // Title text size
              fontFamily: AppTheme.fontFamily, // Modern font
              color: FluentTheme.of(context).brightness == Brightness.dark ? widget.darkFontColor : widget.lightFontColor,
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
                      child: Text('Remove', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                ...databases.map((db) {
                  int index = databases.indexOf(db);
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(FluentIcons.delete),
                              onPressed: () => _removeDatabase(index),
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
                    onPressed: _addDatabase,
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
                    onPressed: _createDatabase,
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
  }
}