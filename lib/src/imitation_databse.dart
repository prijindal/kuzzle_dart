class ImitationDatabase {
  // {index: {collection: {documentid:documentbody}}}
  final Map<String, dynamic> db = <String, dynamic>{};
  final Map<String, dynamic> cache = <String, dynamic>{};

  bool doesIndexExist(String index) => db.containsKey(index);
  bool doesCollectionExist(Map<String, dynamic> jsonRequest) =>
      doesIndexExist(jsonRequest['index']) &&
      (db[jsonRequest['index']] as Map<String, dynamic>)
          .containsKey(jsonRequest['collection']);

  Map<String, dynamic> getCollection(Map<String, dynamic> jsonRequest) =>
      db[jsonRequest['index']][jsonRequest['collection']];
}
