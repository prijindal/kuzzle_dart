const Map<String, dynamic> emptyMap = <String, dynamic>{};

// T should be an enum
String enumToString<T>(T A) => A.toString().split('.')[1];
