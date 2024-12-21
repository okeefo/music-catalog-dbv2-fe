import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
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
  final Set<String> _selectedPublishers = {};
  final Set<String> _selectedAlbums = {};
  final Logger _logger = Logger('FileBrowser');
  bool _isShiftPressed = false;

  @override
  void initState() {
    super.initState();
    widget.publisherAlbums.forEach((key, value) {
      _expandedPublishers[key] = false;
    });
  }

  bool anyAlbumSelected(Set<String> albums) {
    return albums.any((album) => _selectedAlbums.contains(album));
  }

  bool shouldToggleExpansion(String publisher, Set<String> albums) {
    return !isPublisherExpanded(publisher) || !anyAlbumSelected(albums);
  }

  void togglePublisherExpansion(String publisher) {
    setState(() {
      _expandedPublishers[publisher] = !isPublisherExpanded(publisher);
    });
  }

  void removeSelectedAlbums(Set<String> albums) {
    setState(() {
      _selectedAlbums.removeAll(albums);
    });
  }

  bool isPublisherExpanded(String publisher) {
    return _expandedPublishers[publisher] ?? false;
  }

  void handlePublisherClick(String publisher, Set<String> albums) {
    if (shouldToggleExpansion(publisher, albums)) {
      togglePublisherExpansion(publisher);
    }
    removeSelectedAlbums(albums);
  }

  void handleShiftClick(String publisher, Set<String> albums) {
    setState(() {
      if (_selectedPublishers.contains(publisher)) {
        _selectedPublishers.remove(publisher);
      } else {
        _selectedPublishers.add(publisher);
        _selectedAlbums.removeAll(albums);
      }
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
        bool isPublisherSelected = _selectedPublishers.contains(publisher);
    
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Listener(
              onPointerDown: (event) {
                if (HardwareKeyboard.instance.isShiftPressed) {
                  handleShiftClick(publisher, albums);
                } else {
                  handlePublisherClick(publisher, albums);
                }
              },
              child: Container(
                color: isPublisherSelected ? themeProvider.selectedRowColor : Colors.transparent,
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
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: albums.map((album) {
                    bool isAlbumSelected = _selectedAlbums.contains(album);
                    return Listener(
                      onPointerDown: (event) => {
                        setState(() {
                          _logger.info('Toggling expansion album $album for $publisher');
                          if (isAlbumSelected) {
                            _selectedAlbums.remove(album);
                          } else {
                            _selectedAlbums.add(album);
                          }
                          _selectedPublishers.clear();
                        }),
                      },
                      child: Container(
                        color: isAlbumSelected ? themeProvider.selectedRowColor : Colors.transparent,
                        child: ListTile(
                          leading: Icon(FluentIcons.music_note, color: themeProvider.iconColour),
                          title: Text(
                            album,
                            style: TextStyle(
                              color: themeProvider.fontColour,
                              fontSize: themeProvider.fontSizeDataTableRow,
                              fontFamily: themeProvider.dataTableFontFamily,
                            ),
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
