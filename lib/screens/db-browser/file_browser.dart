import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

class FileBrowser extends StatefulWidget {
  final Map<String, Set<String>> publisherAlbums;

  const FileBrowser({
    Key? key,
    required this.publisherAlbums,
  }) : super(key: key);

  @override
  _FileBrowserState createState() => _FileBrowserState();
}

class _FileBrowserState extends State<FileBrowser> {
  final Map<String, bool> _expandedPublishers = {};
  final Logger _logger = Logger('FileBrowser');

  @override
  void initState() {
    super.initState();
    widget.publisherAlbums.forEach((key, value) {
      _expandedPublishers[key] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListView.builder(
      itemCount: widget.publisherAlbums.keys.length,
      itemBuilder: (context, index) {
        String publisher = widget.publisherAlbums.keys.elementAt(index);
        Set<String> albums = widget.publisherAlbums[publisher]!;
        bool isExpanded = _expandedPublishers[publisher] ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Listener(
              onPointerDown: (event) => {
                setState(() {
                  _logger.info('Toggling expansion for $publisher');
                  _expandedPublishers[publisher] = !isExpanded;
                }),
              },
              child: ListTile(
                leading: Icon(
                  isExpanded ? FluentIcons.folder_open : FluentIcons.folder_list,
                  color: themeProvider.iconColour,
                ),
                title: Text(
                  publisher,
                  style: TextStyle(
                    color: themeProvider.fontColour,
                    fontSize: themeProvider.fontSizeDataTableRow,
                    fontFamily: themeProvider.dataTableFontFamily,
                  ),
                ),
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: albums.map((album) {
                    return Listener(
                      onPointerDown: (event) => {
                        setState(() {
                          _logger.info('Toggling expansion album $album for $publisher');
                          _expandedPublishers[publisher] = !isExpanded;
                        }),
                      },
                      child: ListTile(
                        leading: const Icon(FluentIcons.music_note),
                        title: Text(
                          album,
                          style: TextStyle(
                            color: themeProvider.fontColour,
                            fontSize: themeProvider.fontSizeDataTableRow,
                            fontFamily: themeProvider.dataTableFontFamily,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }
}
