class ResponseError extends Error {
  ResponseError({this.status = 520, this.message = 'Unknown Error'});
  ResponseError.fromMap(Map<String, dynamic> map)
      : status = map['status'],
        message = map['message'];
  int status;
  String message;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() =>
      <String, dynamic>{'status': status, 'message': message};
}
