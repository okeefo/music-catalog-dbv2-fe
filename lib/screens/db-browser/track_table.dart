import 'package:flutter/material.dart' as material;
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
      color: theme.fontColour,);
    
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
          rowStyle: rowStyle,
          headerStyle: headerStyle,
        ),
      ),
    );
  }

  List<TrackColumn> _getHeaders() {
    return TrackColumns.getAllColumnsByIndex();
  }

  List<List<String>> _getData() {
    List<TrackColumn> columnOrder = TrackColumns.getAllColumnsByIndex();
    return tracks.map((track) {
      return track.toList(columnOrder).map((item) => item.toString()).toList();
    }).toList();
  }
}
