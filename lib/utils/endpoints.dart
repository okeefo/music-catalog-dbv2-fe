class Endpoints {
  static late final String _baseUri;
  static const String _activeDatabaseUri = 'v1/databases/active';
  static const String _configUri = 'v1/config';
  static const String _initialiseUri = 'v1/databases';
  static const String _mediaScanUri = 'v1/media/scan';
  static const String _tracks = 'v1/tracks';
  static const String _tracksCount = 'v1/tracks/count';

  static void initialize(String baseUri) {
    _baseUri = baseUri;
  }

  static String getActiveDatabaseUri() {
    return '$_baseUri$_activeDatabaseUri';
  }

  static String getConfigUri() {
    return '$_baseUri$_configUri';
  }

  static String postCreateDataBaseUri() {
    return '$_baseUri$_initialiseUri';
  }

  static String scanForMusicUri() {
    return '$_baseUri$_mediaScanUri';
  }

  static String getTracksUri() {
    return '$_baseUri$_tracks';
  }
  
  static String getTotalTracksUri() {
    return '$_baseUri$_tracksCount';
  }
}
