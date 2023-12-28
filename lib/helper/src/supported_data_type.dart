// import 'package:complex_num/complex_num.dart';

import 'package:dtensor/exception/not_supported_type.dart';

class DataTypeHelper<T> {
  bool isSupportedFromNumpy<T>(String type) {
    Type? t = _numpyTypeMap[type];

    if (t == null) {
      throw NotSupportedType(type);
    }

    if ((t == int || t == double) && T == num) {
      return true;
    }

    return t == T;
  }

  Type typeFromNumpy(String data) => _numpyTypeMap[data]!;

  static final Map<String, Type> _numpyTypeMap = {
    'i': int,
    'b': bool,
    'u': int,
    'f': double,
    // 'c': Complex,
    'S': String,
    'U': String,
  };
}
