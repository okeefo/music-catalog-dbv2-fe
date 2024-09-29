class Endpoints {
  static late String activeDatabaseUri;

  static void initialize(String baseUri) {
    activeDatabaseUri = '$baseUri/active-database';
  }
}