import 'package:flutter/material.dart' as material;
import 'track_model.dart';
import 'package:fluent_ui/fluent_ui.dart';

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
        scrollDirection: Axis.horizontal,

        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
                controller: scrollController,

                child: material.DataTable(
                  dividerThickness: 0.1,
                  columnSpacing: 40,
                  headingRowHeight: 40,
                  dataRowMaxHeight: 30,
                  dataRowMinHeight: 20,
                  columns: _getHeader(headerStyle),
                  rows: _getRowData(rowStyle),

                )));
  }

  List<material.DataRow> _getRowData(material.TextStyle textStyle) {
    return tracks.map((track) {
      return material.DataRow(cells: [
        material.DataCell(
          Text(track.id.toString(), style: textStyle),
        ),
        material.DataCell(Text(track.catalogNumber, style: textStyle)),
        material.DataCell(Text(track.label, style: textStyle)),
        material.DataCell(Text(track.albumTitle, style: textStyle)),
        material.DataCell(Text(track.discNumber, style: textStyle)),
        material.DataCell(Text(track.artist, style: textStyle)),
        material.DataCell(Text(track.title, style: textStyle)),
        material.DataCell(Text(track.format, style: textStyle)),
        material.DataCell(Text(track.trackNumber, style: textStyle)),
        material.DataCell(Text(track.discogsId, style: textStyle)),
        material.DataCell(Text(track.year, style: textStyle)),
        material.DataCell(Text(track.country, style: textStyle)),
        material.DataCell(Text(track.discogsUrl, style: textStyle)),
        material.DataCell(Text(track.albumArtist, style: textStyle)),
        material.DataCell(Text(track.fileLocation, style: textStyle)),
        material.DataCell(Text(track.style, style: textStyle)),
        material.DataCell(Text(track.genre, style: textStyle)),
      ]);
    }).toList();
  }

  List<material.DataColumn> _getHeader(material.TextStyle headerStyle) {
    return [
      material.DataColumn(label: Text(TrackColumns.trackId, style: headerStyle), numeric: true),
      material.DataColumn(label: Text(TrackColumns.catalogNumber, style: headerStyle)),
      material.DataColumn(label: Text(TrackColumns.label, style: headerStyle, overflow: TextOverflow.ellipsis)),
      material.DataColumn(label: Text(TrackColumns.albumTitle, style: headerStyle, overflow: TextOverflow.visible)),
      material.DataColumn(label: Text(TrackColumns.discNumber, style: headerStyle)),
      material.DataColumn(label: Text(TrackColumns.artist, style: headerStyle)),
      material.DataColumn(label: Text(TrackColumns.title, style: headerStyle, overflow: TextOverflow.ellipsis)),
      material.DataColumn(label: Text(TrackColumns.format, style: headerStyle)),
      material.DataColumn(label: Text(TrackColumns.trackNumber, style: headerStyle), numeric: true),
      material.DataColumn(label: Text(TrackColumns.discogsId, style: headerStyle)),
      material.DataColumn(label: Text(TrackColumns.year, style: headerStyle)),
      material.DataColumn(label: Text(TrackColumns.country, style: headerStyle)),
      material.DataColumn(label: Text(TrackColumns.discogsUrl, style: headerStyle)),
      material.DataColumn(label: Text(TrackColumns.albumArtist, style: headerStyle)),
      material.DataColumn(label: Text(TrackColumns.fileLocation, style: headerStyle)),
      material.DataColumn(label: Text(TrackColumns.style, style: headerStyle)),
      material.DataColumn(label: Text(TrackColumns.genre, style: headerStyle)),
    ];
  }
}
