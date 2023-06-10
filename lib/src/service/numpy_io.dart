part of './tensor_io.dart';

class _NumpyIO<E> {
  File _save(String name) {
    throw Exception();
  }

  static Map<String, dynamic> _getDescription<T>(String descr) {
    SupportedDataType s = SupportedDataType<T>();
    if (!s.checkDataType<T>(descr[1])) {
      throw Exception();
    }
    return {
      'itemSize': int.parse(descr.substring(2)),
      'byteOrder': descr[0] == '<' ? Endian.little : Endian.big,
      'dtype': s.getType(descr[1])
    };
  }

  static Map<String, dynamic> _load<E>(File file) {
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
    Map<String, dynamic> metaData = {};
    metaData['shape'] = <int>[];

    String modifiedString =
        data.toLowerCase().replaceAll(RegExp('[{}\\s\']'), '');
    RegExp pattern = RegExp(r'\((.*?)\)');
    Match? match = pattern.firstMatch(modifiedString);

    if (match == null) {
      throw Exception();
    }

    String shapePattern = match.group(0)!;
    String withNoShape = modifiedString.replaceAll(shapePattern, '');
    List<String> keyValuePair = withNoShape.split(',');

    for (int i = 0; i < shapePattern.length; i++) {
      int? value = int.tryParse(shapePattern[i]);
      if (value != null) {
        (metaData['shape'] as List<int>).add(value);
      }
    }

    for (String pair in keyValuePair) {
      List<String> keyValue = pair.split(':');
      if (keyValue.length == 2 && keyValue[1].isNotEmpty) {
        if (keyValue[1] == 'true' || keyValue[1] == 'false') {
          metaData[keyValue[0]] = keyValue[1] == 'true';
        } else {
          metaData[keyValue[0]] = keyValue[1];
        }
      }
    }

    return metaData;
  }
}
