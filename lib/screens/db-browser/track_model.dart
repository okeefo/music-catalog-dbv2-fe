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
  });

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
}

class TrackColumns {
  static const String trackId = 'Id';
  static const String catalogNumber = 'Catalog No';
  static const String label = 'Label';
  static const String albumTitle = 'Album';
  static const String discNumber = 'Disc';
  static const String artist = 'Artist';
  static const String title = 'Title';
  static const String format = 'Format';
  static const String trackNumber = 'Track';
  static const String discogsId = 'Discogs Id';
  static const String year = 'Year';
  static const String country = 'Country';
  static const String discogsUrl = 'Discogs Url';
  static const String albumArtist = 'Album Artist';
  static const String fileLocation = 'File Location';
  static const String style = 'Style';
  static const String genre = 'Genre';
}
