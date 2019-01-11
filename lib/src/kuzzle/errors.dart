class KuzzleError extends Error {
  KuzzleError([this.message, this.status, _stack])
      : stack = _stack != null ? _stack : StackTrace.current;

  factory KuzzleError.fromJson(Map<String, dynamic> json) => KuzzleError(
    json['error']['message'],
    json['status']
  );

  final int status;
  final String message;
  final StackTrace stack;

  @override
  String toString() => 'KuzzleError[$status][$message]';
}