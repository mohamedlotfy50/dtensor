import 'package:dtensor/util/src/list_extension.dart';

class TensorExtractorHelper<T> {
  List<T> get flatTensor => _flatMapValues.values.toList();
  final Map<int, T> sparseTensor = {};
  final Map<int, T> _flatMapValues = {};
  final Map<T, int> _histogram = {};

  final List<List<int>> dimCount = [];
  List<int> get shape {
    List<int> result = [];
    if (dimCount.isEmpty) {
      result.add(size);
    } else {
      result.add(dimCount[0].length);
      result.add(dimCount[0].max());
      for (int i = 1; i < dimCount.length; i++) {
        result.add(dimCount[i].max());
      }
    }
    return result;
  }

  int _size = 0;
  T? sparseValue;
  int _maxSparseVlaue = 0;
  int? maxDepth;

  bool get isSparse {
    return _maxSparseVlaue / _size >= 0.95;
  }

  bool? _isRagged;

  bool get isRagged {
    if (_isRagged != null) {
      return _isRagged!;
    }
    for (List<int> dim in dimCount) {
      if (!dim.isSymmetric()) {
        return true;
      }
    }

    return false;
  }

  int get size => _size;

  void addDim({required int index, required int value}) {
    if (index > dimCount.length - 1) {
      for (int i = dimCount.length - 1; i < index; i++) {
        dimCount.add([]);
      }
    }
    dimCount[index].add(value);
  }

  addRowTensorElements(List list, int depth) {
    if (maxDepth != null && depth != maxDepth) {
      throw Exception();
    }
    maxDepth = depth;
    for (int i = 0; i < list.length; i++) {
      if (list[i] is! T) {
        throw Exception();
      }

      _flatMapValues[size] = list[i];
      if (!_histogram.containsKey(list[i])) {
        _histogram[list[i]] = 0;
      }
      _histogram[list[i]] = _histogram[list[i]]! + 1;
      if (sparseValue == null || _maxSparseVlaue < _histogram[list[i]]!) {
        sparseValue = list[i];
        _maxSparseVlaue = _histogram[list[i]]!;
      }
      _size += 1;
    }
  }

  addColumnTensorElements(List list, int depth) {
    if (maxDepth != null && depth != maxDepth) {
      throw Exception();
    }
    maxDepth = depth;
    int maxLength = 0;
    for (List l in list) {
      if (l.length > maxLength) {
        maxLength = l.length;
      }
      for (dynamic element in l) {
        if (element is! T) {
          throw Exception();
        }
      }
    }

    for (int columnIndex = 0; columnIndex < maxLength; columnIndex++) {
      for (int rowIndex = 0; rowIndex < list.length; rowIndex++) {
        try {
          _flatMapValues[size] = list[rowIndex][columnIndex];
          if (sparseValue == null ||
              _maxSparseVlaue < _histogram[list[rowIndex][columnIndex]]!) {
            sparseValue = list[rowIndex][columnIndex];
            _maxSparseVlaue = _histogram[list[rowIndex][columnIndex]]!;
          }

          _size += 1;
        } on RangeError {
          _isRagged = true;
        } catch (e) {
          throw Exception();
        }
      }
    }
  }
}
