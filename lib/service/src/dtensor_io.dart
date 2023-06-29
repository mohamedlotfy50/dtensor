import 'dart:io' show File;

import 'dtensor_io_base.dart';

class DtensorIO<T> extends DtensorIOBase<T> {
  File save<T>(String name) {
    throw Exception();
  }

  Map<String, dynamic> load<T>(File file) {
    throw Exception();
  }
}
