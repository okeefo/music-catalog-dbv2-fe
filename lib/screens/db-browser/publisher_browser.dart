import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

// Constants for repeated values
const double rowHeight = 22.0;
const double iconSize = 14.0;
const EdgeInsets rowPadding = EdgeInsets.symmetric(vertical: 0.0);
const EdgeInsets listTilePadding = EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0);
const EdgeInsets albumListTilePadding = EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0);

class PublisherBrowser extends StatefulWidget {
  final Map<String, Set<String>> publisherAlbums;

  const PublisherBrowser({
    super.key,
    required this.publisherAlbums,
  });

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

  void togglePublisherExpansion(String publisher) {
    setState(() {
      _expandedPublishers[publisher] = !isPublisherExpanded(publisher);
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
            PublisherRow(
              publisher: publisher,
              isExpanded: isExpanded,
              isSelected: isPublisherSelected,
              onClick: () => handleSelectionClick(publisher, _selectedPublishers, _selectedAlbums),
              onIconClick: () => handlePublisherIconClick(publisher),
            ),
            if (isExpanded)
              ...albums.map((album) {
                bool isAlbumSelected = _selectedAlbums.contains(album);
                return AlbumRow(
                  album: album,
                  isSelected: isAlbumSelected,
                  onClick: () => handleSelectionClick(album, _selectedAlbums, _selectedPublishers),
                );
              }),
          ],
        );
      },
    );
  }
}

class PublisherRow extends StatelessWidget {
  final String publisher;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onClick;
  final VoidCallback onIconClick;

  const PublisherRow({
    super.key,
    required this.publisher,
    required this.isExpanded,
    required this.isSelected,
    required this.onClick,
    required this.onIconClick,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Listener(
      onPointerDown: (event) => onClick(),
      child: Container(
        padding: rowPadding,
        color: isSelected ? themeProvider.selectedRowColor : Colors.transparent,
        child: SizedBox(
          height: rowHeight,
          child: ListTile(
            contentPadding: listTilePadding,
            leading: GestureDetector(
              onTap: onIconClick,
              child: Icon(
                isExpanded ? FluentIcons.folder_open : FluentIcons.folder_list,
                color: themeProvider.iconColour,
                size: iconSize,
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
    );
  }
}

class AlbumRow extends StatelessWidget {
  final String album;
  final bool isSelected;
  final VoidCallback onClick;

  const AlbumRow({
    super.key,
    required this.album,
    required this.isSelected,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Listener(
      onPointerDown: (event) => onClick(),
      child: Container(
        padding: rowPadding,
        color: isSelected ? themeProvider.selectedRowColor : Colors.transparent,
        child: SizedBox(
          height: rowHeight,
          child: ListTile(
            contentPadding: albumListTilePadding,
            leading: Icon(FluentIcons.music_note, color: themeProvider.iconColour, size: iconSize),
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
  }
}