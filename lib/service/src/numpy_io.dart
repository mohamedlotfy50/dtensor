import 'dart:convert';
import 'dart:io' show File, RandomAccessFile, FileMode;
import 'dart:typed_data';

import 'package:dtensor/helper/src/supported_data_type.dart';
import 'package:dtensor/util/util.dart';

import 'dtensor_io_base.dart';

class NumpyIO<E> extends DtensorIOBase<E> {
  File save<E>(String name) {
    throw Exception();
  }

  static Map<String, dynamic> _getDescription<T>(String descr) {
    DataTypeHelper dataTypeHelper = DataTypeHelper<T>();
    if (!dataTypeHelper.isSupportedFromNumpy<T>(descr[1])) {
      throw Exception();
    }
    return {
      'itemSize': int.parse(descr.substring(2)),
      'byteOrder': descr[0] == '<' ? Endian.little : Endian.big,
      'dtype': dataTypeHelper.typeFromNumpy(descr[1])
    };
  }

  Map<String, dynamic> load<E>(File file) {
    RandomAccessFile randomAccessFile = file.openSync(mode: FileMode.read);

    // Step 1: Read the header
    final Map<String, dynamic> metadata = _parseHeader<E>(randomAccessFile);
    // Step 3: Determine data type, shape, etc.
    List<int> shape = List<int>.from(metadata['shape']);
    bool isFortran = metadata['fortran_order'];
    int itemSize = metadata['itemSize'];
    Endian byteOrder = metadata['byteOrder'];

    // Step 4: Read the binary data and convert it
    int dataSize = itemSize * shape.sum();

    Uint8List unit8ListData = randomAccessFile.readSync(dataSize);
    List<E> tensor =
        _convertData<E>(unit8ListData, byteOrder, itemSize, metadata['dtype']);
    randomAccessFile.closeSync();

    return {
      'byteOrder': byteOrder,
      'itemSize': itemSize,
      'dataType': E,
      'shape': shape,
      'isFortran': isFortran,
      'data': tensor,
    };
  }

  static Map<String, dynamic> _parseHeader<E>(
      RandomAccessFile randomAccessFile) {
    Uint8List header = randomAccessFile.readSync(10);

    // Step 2: Parse the header to extract metadata
    int headerLength =
        ByteData.sublistView(header, 8, 10).getInt16(0, Endian.little);
    Uint8List full = randomAccessFile.readSync(headerLength);
    String encodedJson = String.fromCharCodes(full);
    Map<String, dynamic> metadata = _numpyParser(encodedJson);
    Map<String, dynamic> desc = _getDescription<E>(metadata['descr']);
    metadata.addAll(desc);
    return metadata;
  }

  static List<T> _convertData<T>(
      Uint8List data, Endian dtype, int elementSize, Type type) {
    // Convert the binary data to the appropriate Dart data type
    int elementCount = data.length ~/ elementSize;

    List<T> dataArray = [];
    ByteData byteData = ByteData.view(data.buffer);
    for (int i = 0; i < elementCount; i++) {
      if (type == int) {
        dataArray.add(byteData.getInt32(i * elementSize, dtype) as T);
      } else if (type == double) {
        dataArray.add(byteData.getFloat64(i * elementSize, dtype) as T);
      } else if (type == bool) {
        dataArray.add((data[i] == 1) as T);
      } else {
        throw Exception();
      }
    }

    return dataArray;
  }
  // {'descr': '<i4', 'fortran_order': False, 'shape': (1,), }   single
  // {'descr': '<i4', 'fortran_order': False, 'shape': (), }      scalar

  static Map<String, dynamic> _numpyParser(String data) {
    final String lowerCase = data.toLowerCase();
    final String modifiedString =
        lowerCase.replaceAllMapped(RegExp(r"['()]"), (match) {
      if (match.group(0) == "'") {
        return '"';
      } else {
        return match.group(0) == "(" ? "[" : "]";
      }
    });
    late final String cleanMetaData;
    int i = modifiedString.length - 1;
    while (i >= 0) {
      if (modifiedString[i] == ',') {
        cleanMetaData =
            modifiedString.substring(0, i) + modifiedString.substring(i + 1);
        break;
      } else if (modifiedString[i] == ']') {
        break;
      }
      i--;
    }

    return json.decode(cleanMetaData);
  }
}
