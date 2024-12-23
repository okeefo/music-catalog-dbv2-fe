import 'track_model.dart';
import 'package:logging/logging.dart';

class TrackFilter {
  static final Logger _logger = Logger('TrackFilter');

  static List<Track> filterTracks(List<Track> tracks, String query, Set<String> selectedPublishers, Set<String> selectedAlbums) {
    tracks = _filterByPublisher(selectedPublishers, tracks);
    tracks = _filterByAlbum(selectedAlbums, tracks);
    return _filterByQuery(query, tracks);
  }

  static List<Track> _filterByAlbum(Set<String> itemsToMatch, List<Track> tracks) {
    if (itemsToMatch.isNotEmpty) {
      tracks = tracks.where((track) => itemsToMatch.contains(track.albumTitle)).toList();
    }
    return tracks;
  }

  static List<Track> _filterByPublisher(Set<String> selectedPublishers, List<Track> tracks) {
    if (selectedPublishers.isNotEmpty) {
      return tracks.where((track) => selectedPublishers.contains(track.label)).toList();
    }
    return tracks;
  }

  static List<Track> _filterByQuery(String query, List<Track> tracksCopy) {
    if (query.isEmpty) {
      return tracksCopy;
    }
    if (query.contains(':')) {
      return _filterBySpecificColumn(tracksCopy, query);
    }
    return _filterByAnyColumn(tracksCopy, query);
  }

  static List<Track> _filterByAnyColumn(List<Track> tracksCopy, String query) {
    return tracksCopy.where((track) {
      return track.title.toLowerCase().contains(query.toLowerCase()) ||
          track.artist.toLowerCase().contains(query.toLowerCase()) ||
          track.albumTitle.toLowerCase().contains(query.toLowerCase()) ||
          track.label.toLowerCase().contains(query.toLowerCase()) ||
          track.genre.toLowerCase().contains(query.toLowerCase()) ||
          track.style.toLowerCase().contains(query.toLowerCase()) ||
          track.country.toLowerCase().contains(query.toLowerCase()) ||
          track.year.toLowerCase().contains(query.toLowerCase()) ||
          track.format.toLowerCase().contains(query.toLowerCase()) ||
          track.catalogNumber.toLowerCase().contains(query.toLowerCase()) ||
          track.discogsId.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  static List<Track> _filterBySpecificColumn(List<Track> tracksCopy, String query) {
    return tracksCopy.where((track) {
      final parts = query.split(':');
      if (parts.length != 2) {
        return false;
      }
      final column = parts[0].toLowerCase();
      final search = parts[1].toLowerCase();

      if (column == 'title') {
        return track.title.toLowerCase().contains(search);
      } else if (column == 'artist') {
        return track.artist.toLowerCase().contains(search);
      } else if (column == 'album') {
        return track.albumTitle.toLowerCase().contains(search);
      } else if (column == 'label') {
        return track.label.toLowerCase().contains(search);
      } else if (column == 'genre') {
        return track.genre.toLowerCase().contains(search);
      } else if (column == 'style') {
        return track.style.toLowerCase().contains(search);
      } else if (column == 'country') {
        return track.country.toLowerCase().contains(search);
      } else if (column == 'year') {
        return track.year.toLowerCase().contains(search);
      } else if (column == 'format') {
        return track.format.toLowerCase().contains(search);
      } else if (column == 'catalog' || column == 'catalogno') {
        return track.catalogNumber.toLowerCase().contains(search);
      } else if (column == 'discogs') {
        return track.discogsId.toLowerCase().contains(search);
      } else {
        return false;
      }
    }).toList();
  }
}

class PublisherFilter {
  static Map<String, Set<String>> filterPublisherAlbums(Map<String, Set<String>> publisherAlbums, String query) {
    if (query.isEmpty) {
      return publisherAlbums;
    }
    final filtered = <String, Set<String>>{};
    publisherAlbums.forEach((publisher, albums) {
      final matchingAlbums = albums.where((album) => album.toLowerCase().contains(query.toLowerCase())).toSet();
      if (publisher.toLowerCase().contains(query.toLowerCase()) || matchingAlbums.isNotEmpty) {
        filtered[publisher] = matchingAlbums.isNotEmpty ? matchingAlbums : albums;
      }
    });
    return filtered;
  }
}
