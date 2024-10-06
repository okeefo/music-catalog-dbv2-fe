class Endpoints {
  static late final String _baseUri;
  static const String _activeDatabaseUri = '/active-database';
  static const String _configUri = '/config';
  static const String _initialiseUri = '/database/{dbName}/initialise';

  static void initialize(String baseUri) {
    _baseUri = baseUri;
  }

  static String getActiveDatabaseUri() {
    return '$_baseUri/$_activeDatabaseUri';
  }

  static String getConfigUri() {
    return '$_baseUri/$_configUri';
  }

  static String getInitialiseUri(String dbName) {
    String uri = _initialiseUri.replaceAll('{dbName}', dbName);
    return '$_baseUri/$uri';
  }
}