import 'dart:io';

abstract class DtensorIOBase<T> {
  File save<T>(String name);

  Map<String, dynamic> load<T>(File file);
}
