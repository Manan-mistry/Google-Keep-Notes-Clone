class AppUrl {

  static const String apiKey = "";

  static const String baseUrl = "https://fdd73b37-0f57-4f60-8e6c-197adfbb9b90.mock.pstmn.io";

  static String getBaseUrl() {
    return baseUrl;
  }

  static String login = "${getBaseUrl()}/mock-login";
  static String getNotes = "${getBaseUrl()}/mock-notes-list";
  static String addNote = "${getBaseUrl()}/mock-add-note";


  static const int successStatusCode = 200;
  static const int validationErrorStatusCode = 222;
  static const int parsingErrorStatusCode = 400;
  static const int unauthorized = 401;
  static const int forceLogoutStatusCode = 403;
  static const int requestedResourceNotFound = 404;
  static const int internalServer = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
}