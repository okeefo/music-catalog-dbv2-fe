import 'package:flutter/material.dart' as material;
import 'track_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'resizable_table.dart';

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
    const rowStyle = material.TextStyle(fontWeight: material.FontWeight.w300, fontFamily: 'JetBrainsMono Nerd Font', fontSize: 11);
    const headerStyle = material.TextStyle(fontWeight: material.FontWeight.bold, fontFamily: 'JetBrainsMono Nerd Font', fontSize: 12);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
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

  List<String> _getHeadersOrig() {
    return TrackColumns.getAllColumnsByIndex().map((column) => column.name).toList();
  }

  List<List<String>> _getData() {
    List<TrackColumn> columnOrder = TrackColumns.getAllColumnsByIndex();
    return tracks.map((track) {
      return track.toList(columnOrder).map((item) => item.toString()).toList();
    }).toList();
  }
}
