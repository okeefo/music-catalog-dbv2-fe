class Endpoints {
  static late final String _baseUri;
  static const String _activeDatabaseUri = 'databases/active';
  static const String _configUri = 'config';
  static const String _initialiseUri = 'databases';
  static const String _mediaScanUri = 'media/scan';


  static void initialize(String baseUri) {
    _baseUri = baseUri;
  }

  static String getActiveDatabaseUri() {
    return '$_baseUri/$_activeDatabaseUri';
  }

  static String getConfigUri() {
    return '$_baseUri/$_configUri';
  }

  static String postCreateDataBaseUri() {
    return '$_baseUri/$_initialiseUri';
  }

  static String scanForMusicUri() {
    return '$_baseUri/$_mediaScanUri';
  }
}
