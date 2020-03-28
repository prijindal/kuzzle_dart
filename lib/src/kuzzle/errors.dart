import 'response.dart';

class KuzzleError extends Error {
  KuzzleError([this.message, this.status, StackTrace _stack])
      : stack = _stack ?? StackTrace.current;

  factory KuzzleError.fromJson(Map<String, dynamic> json) =>
      KuzzleError(json['error']['message'] as String, json['status'] as int);

  final int status;
  final String message;
  final StackTrace stack;

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
      };

  @override
  String toString() => 'KuzzleError[$status][$message]';
}

class BadResponseFormatError extends KuzzleError {
  BadResponseFormatError(String message, this.response) : super(message, 400);

  final KuzzleResponse response;
}
