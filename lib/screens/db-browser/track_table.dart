import 'package:front_end/providers/table_settings_provider.dart';
import 'package:front_end/screens/db-browser/track_provider.dart';
import 'package:front_end/screens/popups.dart';
import 'package:provider/provider.dart';
import 'track_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'resizable_table.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:logging/logging.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class TrackTable extends StatelessWidget {
  final List<Track> tracks;
  final ScrollController scrollController;
  final FlyoutController menuController = FlyoutController();
  final Logger _logger = Logger('TrackTable');
  final TrackProvider _trackProvider = TrackProvider();
  final Function(Track) onTrackSelected;
  final double borderWidth = 0.5;

  TrackTable({
    super.key,
    required this.tracks,
    required this.scrollController,
    required this.onTrackSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final tableSettingsProvider = Provider.of<TableSettingsProvider>(context, listen: false);

    final rowDecoration = getCellDecoration(theme.tableBackgroundColour, theme.tableBorderColour);
    final altDecoration = getCellDecoration(theme.tableAltBackgroundColour, theme.tableBorderColour);
    final headerDecoration = getCellDecoration(theme.headerBackgroundColour, theme.tableBorderColour);
    final selectDecoration = getCellDecoration(theme.tableSelectBackgroundColour, theme.tableBorderColour);

    return FlyoutTarget(
      controller: menuController,
      child: ResizableTable(
        headers: _getHeaders(),
        data: _getData(),
        columnActions: _getColumnBehaviors(),
        rowStyle: theme.styleTableRow,
        altRowStyle: theme.styleTableAltRow,
        selectRowStyle: theme.styleTableSelectRow,
        headerStyle: theme.styleTableHeader,
        onRightClick: (context, position, columnIndex, rowIndex, d) {
          _showContextMenu(context, position, columnIndex, rowIndex, d);
        },
        infiniteScrollController: scrollController,
        rowDecoration: rowDecoration,
        altDecoration: altDecoration,
        headerDecoration: headerDecoration,
        selectDecoration: selectDecoration,
        altRowColumnIndex: 1,
        tableSettingsProvider: tableSettingsProvider,
        onRowTap: (rowIndex) {
          if (rowIndex == -1) {
            _logger.info("de-selected track");
            return;
          }
          onTrackSelected(tracks[rowIndex]);
        },
      ),
    );
  }

  BoxDecoration getCellDecoration(Color backgroundColor, Color borderColour) {
    return BoxDecoration(
      border: Border.all(color: borderColour, width: borderWidth),
      color: backgroundColor,
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
            leading: const Icon(FluentIcons.play),
            text: const Text('Play'),
            onPressed: () => _playTrack(context, rowIndex),
          ),
          MenuFlyoutItem(
            leading: const Icon(FluentIcons.stop),
            text: const Text('Stop', style: TextStyle(fontSize: 12)),
            onPressed: () => _trackProvider.stopTrack(),
          ),
          MenuFlyoutItem(
            leading: const Icon(FluentIcons.pause),
            text: const Text('Pause'),
            onPressed: () => _showNotImplementedDialog(context),
          ),
          const MenuFlyoutSeparator(),
          MenuFlyoutItem(
            text: const Text('Rename'),
            onPressed: () => _showNotImplementedDialog(context),
          ),
          MenuFlyoutItem(
            text: const Text('Select'),
            onPressed: () => _showNotImplementedDialog(context),
          ),
          const MenuFlyoutSeparator(),
          MenuFlyoutSubItem(
            text: const Text('Send to'),
            items: (_) => [
              MenuFlyoutItem(
                text: const Text('Bluetooth'),
                onPressed: () => _showNotImplementedDialog(context),
              ),
              MenuFlyoutItem(
                text: const Text('Desktop (shortcut)'),
                onPressed: () => _showNotImplementedDialog(context),
              ),
              MenuFlyoutSubItem(
                text: const Text('Compressed file'),
                items: (context) => [
                  MenuFlyoutItem(
                    text: const Text('Compress and email'),
                    onPressed: () => _showNotImplementedDialog(context),
                  ),
                  MenuFlyoutItem(
                    text: const Text('Compress to .7z'),
                    onPressed: () => _showNotImplementedDialog(context),
                  ),
                  MenuFlyoutItem(
                    text: const Text('Compress to .zip'),
                    onPressed: () => _showNotImplementedDialog(context),
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
    _logger.warning('Not implemented');
    showErrorDialog(context, "Nothing to see here", "Not Implemented");
  }

  _playTrack(BuildContext context, int rowIndex) {
    _trackProvider.playTrack(tracks[rowIndex], (errorMessage) {
      if (context.mounted) {
        showErrorDialog(context, errorMessage, ' Playback Failure');
      }
    });
  }
}
