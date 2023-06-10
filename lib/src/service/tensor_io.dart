import 'dart:io';
import 'dart:typed_data';

import 'package:dtensor/src/helper/list_extension.dart';

import '../model/supported_data_type.dart';
part './numpy_io.dart';
part './dtensor_io.dart';

class TensorIO<T> {
  File _save(String name) {
    throw Exception();
  }

  static Map<String, dynamic> load<T>(File file) {
    String fileExtension = file.path.split('.').last;

    if (fileExtension == 'npy') {
      return _NumpyIO._load<T>(file);
    } else if (fileExtension == 'dt') {
      return _DtensorIO._load<T>(file);
    }
    throw Exception();
  }
}
