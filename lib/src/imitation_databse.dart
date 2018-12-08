class ImitationDatabase {
  // {index: {collection: {documentid:documentbody}}}
  final Map<String, dynamic> db = <String, dynamic>{};

  bool doesIndexExist(String index) => db.containsKey(index);
  bool doesCollectionExist(dynamic jsonRequest) =>
      doesIndexExist(jsonRequest['index']) &&
      (db[jsonRequest['index']] as Map<String, dynamic>)
          .containsKey(jsonRequest['collection']);

  Map<String, dynamic> getCollection(dynamic jsonRequest) =>
      db[jsonRequest['index']][jsonRequest['collection']];
}
