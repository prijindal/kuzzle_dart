class RawKuzzleResponse {
  RawKuzzleResponse.fromMap(Map<String, dynamic> map);
  int status;
  String error;
  String requestId;
  String controller;
  String action;
  String collection;
  String index;
  Map<String, dynamic> result;
}

class NotificationResponse {}
