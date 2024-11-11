class Track {
  final int id;
  final String catalogNumber;
  final String label;
  final String albumTitle;
  final String discNumber;
  final String artist;
  final String title;
  final String format;
  final String trackNumber;
  final String discogsId;
  final String year;
  final String country;
  final String discogsUrl;
  final String albumArtist;
  final String fileLocation;
  final String style;
  final String genre;
  final bool fileExists;

  late final Map<TrackColumn, dynamic> columnMap;

  Track({
    required this.id,
    required this.catalogNumber,
    required this.label,
    required this.albumTitle,
    required this.discNumber,
    required this.artist,
    required this.title,
    required this.format,
    required this.trackNumber,
    required this.discogsId,
    required this.year,
    required this.country,
    required this.discogsUrl,
    required this.albumArtist,
    required this.fileLocation,
    required this.style,
    required this.genre,
    required this.fileExists,
  }) {
    columnMap = {
      TrackColumns.trackId: id,
      TrackColumns.catalogNumber: catalogNumber,
      TrackColumns.label: label,
      TrackColumns.albumTitle: albumTitle,
      TrackColumns.discNumber: discNumber,
      TrackColumns.artist: artist,
      TrackColumns.title: title,
      TrackColumns.format: format,
      TrackColumns.trackNumber: trackNumber,
      TrackColumns.discogsId: discogsId,
      TrackColumns.year: year,
      TrackColumns.country: country,
      TrackColumns.discogsUrl: discogsUrl,
      TrackColumns.albumArtist: albumArtist,
      TrackColumns.fileLocation: fileLocation,
      TrackColumns.style: style,
      TrackColumns.genre: genre,
      TrackColumns.fileExists: fileExists,
    };
  }

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['track_id'] ?? '0',
      catalogNumber: json['catalog_number'] ?? '-',
      label: json['label'] ?? '-',
      albumTitle: json['album_title'] ?? '-',
      discNumber: json['disc_number']?.toString() ?? '-',
      artist: json['track_artist'] ?? '-',
      title: json['track_title'] ?? '-',
      format: json['format'] ?? '-',
      trackNumber: json['track_number']?.toString() ?? '-',
      discogsId: json['discogs_id'] ?? '-',
      year: json['year'] ?? '-',
      country: json['country'] ?? '-',
      discogsUrl: json['discogs_url'] ?? '-',
      albumArtist: json['album_artist'] ?? '-',
      fileLocation: json['file_location'] ?? '-',
      style: json['style'] ?? '-',
      genre: json['genre'] ?? '-',
      fileExists: json['file_exists'] ?? false,
    );
  }

  // Method to get a single item by column name using the pre-built map
  dynamic getItem(TrackColumn columnName) {
    return columnMap[columnName];
  }

  // Method to return track data as a list of values in the specified order
  List<dynamic> toList(List<TrackColumn> columnOrder) {
    return columnOrder.map((column) => getItem(column)).toList();
  }
}

class TrackColumns {
  static TrackColumn trackId = TrackColumn(name: 'Id', index: 0, isVisible: true);
  static TrackColumn discogsId = TrackColumn(name: 'Discogs Id', index: 1, isVisible: true);
  static TrackColumn catalogNumber = TrackColumn(name: 'Catalog No', index: 2, isVisible: true);
  static TrackColumn label = TrackColumn(name: 'Label', index: 3, isVisible: true);
  static TrackColumn albumTitle = TrackColumn(name: 'Album', index: 4, isVisible: true);
  static TrackColumn discNumber = TrackColumn(name: 'Disc', index: 5, isVisible: true);
  static TrackColumn artist = TrackColumn(name: 'Artist', index: 6, isVisible: true);
  static TrackColumn title = TrackColumn(name: 'Title', index: 7, isVisible: true);
  static TrackColumn format = TrackColumn(name: 'Format', index: 8, isVisible: true);
  static TrackColumn trackNumber = TrackColumn(name: 'Track', index: 9, isVisible: true);

  static TrackColumn year = TrackColumn(name: 'Year', index: 10, isVisible: true);
  static TrackColumn country = TrackColumn(name: 'Country', index: 11, isVisible: true);
  static TrackColumn discogsUrl = TrackColumn(name: 'Discogs Url', index: 12, isVisible: false);
  static TrackColumn albumArtist = TrackColumn(name: 'Album Artist', index: 13, isVisible: true);
  static TrackColumn fileLocation = TrackColumn(name: 'File Location', index: 14, isVisible: true);
  static TrackColumn style = TrackColumn(name: 'Style', index: 15, isVisible: true);
  static TrackColumn genre = TrackColumn(name: 'Genre', index: 16, isVisible: true);
  static TrackColumn fileExists = TrackColumn(name: 'found', index: 17, isVisible: false);

  static List<TrackColumn> getAllColumnsByIndex() {
    return List<TrackColumn>.filled(18, TrackColumn(name: '', index: 0, isVisible: false))
      ..[TrackColumns.trackId.index] = TrackColumns.trackId
      ..[TrackColumns.catalogNumber.index] = TrackColumns.catalogNumber
      ..[TrackColumns.label.index] = TrackColumns.label
      ..[TrackColumns.albumTitle.index] = TrackColumns.albumTitle
      ..[TrackColumns.discNumber.index] = TrackColumns.discNumber
      ..[TrackColumns.artist.index] = TrackColumns.artist
      ..[TrackColumns.title.index] = TrackColumns.title
      ..[TrackColumns.format.index] = TrackColumns.format
      ..[TrackColumns.trackNumber.index] = TrackColumns.trackNumber
      ..[TrackColumns.discogsId.index] = TrackColumns.discogsId
      ..[TrackColumns.year.index] = TrackColumns.year
      ..[TrackColumns.country.index] = TrackColumns.country
      ..[TrackColumns.discogsUrl.index] = TrackColumns.discogsUrl
      ..[TrackColumns.albumArtist.index] = TrackColumns.albumArtist
      ..[TrackColumns.fileLocation.index] = TrackColumns.fileLocation
      ..[TrackColumns.style.index] = TrackColumns.style
      ..[TrackColumns.genre.index] = TrackColumns.genre
      ..[TrackColumns.fileExists.index] = TrackColumns.fileExists;
  }
}

class TrackColumn {
  final String name;
  final int index;
  final bool isVisible;

  TrackColumn({
    required this.name,
    required this.index,
    required this.isVisible,
  });

  TrackColumn copyWith({
    String? displayName,
    int? index,
    bool? isVisible,
  }) {
    return TrackColumn(
      name: displayName ?? this.name,
      index: index ?? this.index,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
