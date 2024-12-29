class Endpoints {
  static late final String _baseUriHttp;
  static late final String _baseUriWs;
  static const String _activeDatabaseUri = 'v1/databases/active';
  static const String _configUri = 'v1/config';
  static const String _initialiseUri = 'v1/databases';
  static const String _mediaScanUri = 'v1/media/scan';
  static const String _tracks = 'v1/tracks';
  static const String _tracksCount = 'v1/tracks/count';
  static const String _wsScanUpdates = 'v1/ws';
  

  static void initialize(String baseUri) {
    _baseUriHttp = "http://$baseUri";
    _baseUriWs = "ws://$baseUri";
  }

  static String getActiveDatabaseUri() {
    return '$_baseUriHttp$_activeDatabaseUri';
  }

  static String getConfigUri() {
    return '$_baseUriHttp$_configUri';
  }

  static String postCreateDataBaseUri() {
    return '$_baseUriHttp$_initialiseUri';
  }

  static String scanForMusicUri() {
    return '$_baseUriHttp$_mediaScanUri';
  }

  static String getTracksUri() {
    return '$_baseUriHttp$_tracks';
  }
  
  static String getTotalTracksUri() {
    return '$_baseUriHttp$_tracksCount';
  }

  static String wsScanUpdatesUri() {
    return '$_baseUriWs$_wsScanUpdates';
  }
}
