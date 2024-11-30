import 'package:flutter/material.dart' as material;
import 'package:front_end/screens/popups.dart';
import 'package:provider/provider.dart';
import 'track_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'resizable_table.dart';
import 'package:front_end/providers/theme_provider.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class TrackTable extends StatelessWidget {
  final List<Track> tracks;
  final ScrollController scrollController;
  final FlyoutController menuController = FlyoutController();

  TrackTable({
    super.key,
    required this.tracks,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    final rowStyle = TextStyle(
      fontWeight: theme.dataTableFontWeightNormal,
      fontFamily: theme.fontStyleDataTable,
      fontSize: theme.fontSizeDataTableRow,
      color: theme.fontColour,
    );

    final altRowStyle = TextStyle(
      fontWeight: theme.dataTableFontWeightNormal,
      fontFamily: theme.fontStyleDataTable,
      fontSize: theme.fontSizeDataTableRow,
      color: theme.fontColour,
    );

    final headerStyle = TextStyle(
      fontWeight: theme.dataTableFontWeightBold,
      fontFamily: theme.fontStyleDataTable,
      fontSize: theme.fontSizeDataTableHeader,
      color: theme.headerFontColour,
      backgroundColor: theme.transparent,
    );

    final colDeco = BoxDecoration(
      border: Border.all(color: theme.tableBorderColour, width: 1.0),
      color: theme.headerBackgroundColour,
    );

    final rowDelco = BoxDecoration(
      border: Border.all(color: theme.tableBorderColour, width: 1.0),
      color: theme.rowBackgroundColour,
    );

    final altRowDeco = BoxDecoration(
      border: Border.all(color: theme.tableBorderColour, width: 1.0),
      color: theme.rowAltBackgroundColour,
    );

    return FlyoutTarget(
      controller: menuController,
      child: ResizableTable(
        headers: _getHeaders(),
        data: _getData(),
        columnActions: _getColumnBehaviors(),
        rowStyle: rowStyle,
        altRowStyle: altRowStyle,
        headerStyle: headerStyle,
        onRightClick: (context, position, columnIndex, rowIndex, d) {
          _showContextMenu(context, position, columnIndex, rowIndex, d);
        },
        infiniteScrollController: scrollController,
        columnDecoration: colDeco,
        rowCellDecoration: rowDelco,
        altRowDecoration: altRowDeco,
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

  void _showContextMenu(BuildContext context, Offset position, int columnIndex, int rowIndex, TapDownDetails d) {
    // This calculates the position of the flyout according to the parent navigator

    menuController.showFlyout(
      barrierDismissible: true,
      dismissOnPointerMoveAway: true,
      dismissWithEsc: true,
      position: d.globalPosition,
      navigatorKey: rootNavigatorKey.currentState,
      builder: (context) {
        return MenuFlyout(items: [
          MenuFlyoutItem(
            leading: const Icon(FluentIcons.share),
            text: const Text('Share'),
            onPressed: Flyout.of(context).close,
          ),
          MenuFlyoutItem(
            leading: const Icon(FluentIcons.copy),
            text: const Text('Select Text', style: TextStyle(fontSize: 12)),
            onPressed: () => _showNotImplementedDialog(context),
          ),
          MenuFlyoutItem(
            leading: const Icon(FluentIcons.delete),
            text: const Text('Delete'),
            onPressed: Flyout.of(context).close,
          ),
          const MenuFlyoutSeparator(),
          MenuFlyoutItem(
            text: const Text('Rename'),
            onPressed: Flyout.of(context).close,
          ),
          MenuFlyoutItem(
            text: const Text('Select'),
            onPressed: Flyout.of(context).close,
          ),
          const MenuFlyoutSeparator(),
          MenuFlyoutSubItem(
            text: const Text('Send to'),
            items: (_) => [
              MenuFlyoutItem(
                text: const Text('Bluetooth'),
                onPressed: Flyout.of(context).close,
              ),
              MenuFlyoutItem(
                text: const Text('Desktop (shortcut)'),
                onPressed: Flyout.of(context).close,
              ),
              MenuFlyoutSubItem(
                text: const Text('Compressed file'),
                items: (context) => [
                  MenuFlyoutItem(
                    text: const Text('Compress and email'),
                    onPressed: Flyout.of(context).close,
                  ),
                  MenuFlyoutItem(
                    text: const Text('Compress to .7z'),
                    onPressed: Flyout.of(context).close,
                  ),
                  MenuFlyoutItem(
                    text: const Text('Compress to .zip'),
                    onPressed: Flyout.of(context).close,
                  ),
                ],
              ),
            ],
          ),
        ]);
      },
    );
  }

  void _showNotImplementedDialog(BuildContext context) {
    Flyout.of(context).close();
    showErrorDialog(context, "Nothing to see here", "Not Implemented");
  }
}
