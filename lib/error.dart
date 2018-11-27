class ResponseError extends Error {
  ResponseError({this.status = 520, this.message = 'Unknown Error'});
  int status;
  String message;

  @override
  String toString() {
    return {'status': status, 'message': message}.toString();
  }
}
