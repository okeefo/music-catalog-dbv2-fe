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
    const rowStyle = material.TextStyle(fontWeight: material.FontWeight.w300,
        fontFamily: 'JetBrainsMono Nerd Font',
        fontSize: 11);
    const headerStyle = material.TextStyle(fontWeight: material.FontWeight.bold,
        fontFamily: 'JetBrainsMono Nerd Font',
        fontSize: 12);

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

  List<String> _getHeaders() {
    return [
      TrackColumns.trackId,
      TrackColumns.catalogNumber,
      TrackColumns.label,
      TrackColumns.albumTitle,
      TrackColumns.discNumber,
      TrackColumns.artist,
      TrackColumns.title,
      TrackColumns.format,
      TrackColumns.trackNumber,
      TrackColumns.discogsId,
      TrackColumns.year,
      TrackColumns.country,
      TrackColumns.discogsUrl,
      TrackColumns.albumArtist,
      TrackColumns.fileLocation,
      TrackColumns.style,
      TrackColumns.genre,
    ];
  }

  List<List<String>> _getData() {
    return tracks.map((track) {
      return [
        track.id.toString(),
        track.catalogNumber,
        track.label,
        track.albumTitle,
        track.discNumber,
        track.artist,
        track.title,
        track.format,
        track.trackNumber,
        track.discogsId,
        track.year,
        track.country,
        track.discogsUrl,
        track.albumArtist,
        track.fileLocation,
        track.style,
        track.genre,
      ];
    }).toList();
  }
}

