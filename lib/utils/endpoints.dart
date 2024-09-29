class Endpoints {
  static late String activeDatabaseUri;
  static late String configUri;
  static void initialize(String baseUri) {
    activeDatabaseUri = '$baseUri/active-database';
    configUri = '$baseUri/config';
  }
}
