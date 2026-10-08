class ApiError {

  String message;
  int status;
  dynamic response;

  ApiError(this.response ,this.message, this.status);
}