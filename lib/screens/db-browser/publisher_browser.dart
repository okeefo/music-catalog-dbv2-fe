import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

class PublisherBrowser extends StatefulWidget {
  final Map<String, Set<String>> publisherAlbums;

  const PublisherBrowser({
    Key? key,
    required this.publisherAlbums,
  }) : super(key: key);

  @override
  _PublisherBrowserState createState() => _PublisherBrowserState();
}

class _PublisherBrowserState extends State<PublisherBrowser> {
  final Map<String, bool> _expandedPublishers = {};
  final Set<String> _selectedPublishers = {};
  final Set<String> _selectedAlbums = {};
  final Logger _logger = Logger('PublisherBrowser');

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

  void handleSelectionClick(String selectedItem, Set<String> selectedItems, Set<String> listToClear) {
    setState(() {
      if (HardwareKeyboard.instance.isShiftPressed) {
        if (selectedItems.contains(selectedItem)) {
          selectedItems.remove(selectedItem);
        } else {
          selectedItems.add(selectedItem);
        }
      } else {
        if (selectedItems.contains(selectedItem)) {
          selectedItems.clear();
        } else {
          selectedItems.clear();
          selectedItems.add(selectedItem);
        }
      }
      listToClear.clear();
    });
  }

  void handlePublisherIconClick(String publisher) {
    togglePublisherExpansion(publisher);
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
                handleSelectionClick(publisher, _selectedPublishers, _selectedAlbums);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                color: isPublisherSelected ? themeProvider.selectedRowColor : Colors.transparent,
                child: SizedBox(
                  height: 22.00,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                    leading: GestureDetector(
                      onTap: () {
                        handlePublisherIconClick(publisher);
                      },
                      child: Icon(
                        isExpanded ? FluentIcons.folder_open : FluentIcons.folder_list,
                        color: themeProvider.iconColour,
                        size: 14,
                      ),
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
            ),
            if (isExpanded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: albums.map((album) {
                  bool isAlbumSelected = _selectedAlbums.contains(album);
                  return Listener(
                    onPointerDown: (event) {
                      handleSelectionClick(album, _selectedAlbums, _selectedPublishers);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 0.0),
                      color: isAlbumSelected ? themeProvider.selectedRowColor : Colors.transparent,
                      child: SizedBox(
                        height: 22.00,
                        child: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                          leading: Icon(FluentIcons.music_note, color: themeProvider.iconColour, size: 14),
                          title: Text(
                            album,
                            style: TextStyle(
                              color: themeProvider.fontColour,
                              fontSize: themeProvider.fontSizeDataTableRow,
                              fontFamily: themeProvider.dataTableFontFamily,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }
}
