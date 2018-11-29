import 'helpers.dart';

class RequestStatistics {
  RequestStatistics.fromMap([Map<String, dynamic> map = emptyMap])
      : websocket = map['websocket'],
        http = map['http'],
        mqtt = map['mqtt'];

  int websocket;
  int http;
  int mqtt;
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
}
