import 'package:flutter/material.dart' as material;
import 'package:front_end/screens/popups.dart';
import 'package:provider/provider.dart';
import 'track_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'resizable_table.dart';
import 'package:front_end/providers/theme_provider.dart';

class TrackTable extends StatelessWidget {
  final List<Track> tracks;
  final ScrollController scrollController;

  const TrackTable({
    super.key,
    required this.tracks,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    final rowStyle = material.TextStyle(
      fontWeight: theme.dataTableFontWeightNormal,
      fontFamily: theme.fontStyleDataTable,
      fontSize: theme.fontSizeDataTableRow,
      color: theme.fontColour,
    );

    final headerStyle = material.TextStyle(
      fontWeight: theme.dataTableFontWeightBold,
      fontFamily: theme.fontStyleDataTable,
      fontSize: theme.fontSizeDataTableHeader,
      color: theme.boldFontColour,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: scrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ResizableTable(
          headers: _getHeaders(),
          data: _getData(),
          columnActions: _getColumnBehaviors(),
          rowStyle: rowStyle,
          headerStyle: headerStyle,
          onRightClick: (context, position, columnIndex, rowIndex) {
            _showContextMenu(context, position, columnIndex, rowIndex);
          },
        ),
      ),
    );
  }

  List<ResizeColumn> _getHeaders() {
    return TrackColumns.getAllColumnsByIndex();
  }

  List<List<String>> _getData() {
    List<ResizeColumn> columnOrder = TrackColumns.getAllColumnsByIndex();
    return tracks.map((track) {
      return track.toList(columnOrder).map((item) => item.toString()).toList();
    }).toList();
  }

  Map<int, ColumnAction> _getColumnBehaviors() {
    return {
      TrackColumns.discogsId.index: ColumnAction(type: ColumnActionType.displayAsUrl, urlColumnIndex: TrackColumns.discogsUrl.index),
      TrackColumns.title.index: ColumnAction(type: ColumnActionType.displayAsFileUrl, urlColumnIndex: TrackColumns.fileLocation.index),
      // Add more behaviors as needed
    };
  }

  void _showContextMenu(BuildContext context, Offset position, int columnIndex, int rowIndex) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    material.showMenu(
      context: context,
      color: themeProvider.greyBackground.withOpacity(0.9),
      position: RelativeRect.fromRect(
        position & const Size(40, 40), // smaller rect, the touch area
        Offset.zero & overlay.size, // Bigger rect, the entire screen
      ),
      items: [
        material.PopupMenuItem(
          height: 20,
          child: const Text('Select Text', style: TextStyle(fontSize: 12)),
          onTap: () {
            // Select the text within the cell
            _showNotImplementedDialog(context);
          },
        ),
        material.PopupMenuItem(
          height: 20,
          child: const Text('Select Row', style: material.TextStyle(fontSize: 12)),
          onTap: () {
            // Select the text for every cell in that row
            _showNotImplementedDialog(context);
          },
        ),
        material.PopupMenuItem(
          height: 20,
          child: const Text('Resize All Columns', style: material.TextStyle(fontSize: 12)),
          onTap: () {
            // Implement logic here
            _showNotImplementedDialog(context);
          },
        ),
        material.PopupMenuItem(
          height: 20,
          child: const Text('Resize Column', style: material.TextStyle(fontSize: 12)),
          onTap: () {
            // Show "not Implemented" dialog
            _showNotImplementedDialog(context);
          },
        ),
        material.PopupMenuItem(
          height: 20,
          child: const Text('Play', style: material.TextStyle(fontSize: 12)),
          onTap: () {
            // Show "not Implemented" dialog
            _showNotImplementedDialog(context);
          },
        ),
        material.PopupMenuItem(
          height: 20,
          child: const Text('Stop', style: material.TextStyle(fontSize: 12)),
          onTap: () {
            // Show "not Implemented" dialog
            _showNotImplementedDialog(context);
          },
        ),
      ],
    );
  }

  void _showNotImplementedDialog(BuildContext context) {
    showErrorDialog(context,  "Nothing to see here", "Not Implemented");
  }
}
