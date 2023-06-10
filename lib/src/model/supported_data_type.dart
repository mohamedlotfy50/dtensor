// import 'package:complex_num/complex_num.dart';

class SupportedDataType<T> {
  bool checkDataType<T>(String type) {
    Type? t = _dataTypes[type];

    if (t == null) {
      throw Exception();
    }

    if ((t == int || t == double) && T == num) {
      return true;
    }

    return t == T;
  }

  Type getType(String data) => _dataTypes[data]!;

  static final Map<String, Type> _dataTypes = {
    'i': int,
    'b': bool,
    'u': int,
    'f': double,
    // 'c': Complex,
    'S': String,
    'U': String,
  };
}
