import 'dart:io' show File;
import 'dtensor_io.dart';
import 'numpy_io.dart';

class TensorIO<T> {
  File save(String name) {
    String fileExtension = name.split('.').last;

    if (fileExtension == 'npy') {
      return NumpyIO().save<T>(name);
    } else if (fileExtension == 'dt') {
      return DtensorIO().save<T>(name);
    }
    throw Exception();
  }

  static Map<String, dynamic> load<T>(File file) {
    String fileExtension = file.path.split('.').last;

    if (fileExtension == 'npy') {
      return NumpyIO().load<T>(file);
    } else if (fileExtension == 'dt') {
      return DtensorIO().load<T>(file);
    }
    throw Exception();
  }
}
