class Rights {
  Rights.fromMap(Map<String, dynamic> map)
      : controller = map['controller'],
        action = map['action'],
        index = map['index'],
        collection = map['collection'],
        value = map['value'];

  final String controller;
  final String action;
  final String index;
  final String collection;
  final String value;

  @override
  String toString() => toMap().toString();

  Map<String, dynamic> toMap() => {
        'controller': controller,
        'action': action,
        'index': index,
        'collection': collection,
        'value': value,
      };
}
