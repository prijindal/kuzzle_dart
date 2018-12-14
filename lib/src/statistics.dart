import 'helpers.dart';

class RequestStatistics {
  RequestStatistics.fromMap([Map<String, dynamic> map = emptyMap])
      : websocket = map['websocket'],
        http = map['http'],
        mqtt = map['mqtt'];

  int websocket;
  int http;
  int mqtt;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => {
        'websocket': websocket,
        'http': http,
        'mqtt': mqtt,
      };
}

class Statistics {
  Statistics.fromMap(Map<String, dynamic> map)
      : timestamp = map['timestamp'],
        completedRequests = RequestStatistics.fromMap(map['completedRequests']),
        failedRequests = RequestStatistics.fromMap(map['failedRequests']),
        ongoingRequests = RequestStatistics.fromMap(map['ongoingRequests']),
        connections = RequestStatistics.fromMap(map['connections']);

  RequestStatistics completedRequests;
  RequestStatistics failedRequests;
  RequestStatistics ongoingRequests;
  RequestStatistics connections;
  int timestamp;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => {
        'completedRequests': completedRequests,
        'failedRequests': failedRequests,
        'ongoingRequests': ongoingRequests,
        'connections': connections,
        'timestamp': timestamp,
      };
}
