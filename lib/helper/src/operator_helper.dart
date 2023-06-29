import '../../const/memory_order.dart';
import '../../model/model.dart';
import '../../tensor/tensor.dart';

class OperatorHelper<T extends Object> {
  Map<T, int> _histogram = {};
  List<T> _result = [];
  T? _sparseValue;
  int _maxCount = 0;

  bool get _isSparse => _maxCount / _result.length >= 0.95;

  Map<int, T> get _mapValue {
    Map<int, T> value = {};
    for (int i = 0; i < _result.length; i++) {
      if (_result[i] != _sparseValue) {
        value[i] = _result[i];
      }
    }
    return value;
  }

  void addResult(T value) {
    if (_histogram[value] == null) {
      _histogram[value] = 0;
    }
    _histogram[value] = _histogram[value]! + 1;

    if (_sparseValue == null || _histogram[value]! > _maxCount) {
      _sparseValue = value;
      _maxCount = _histogram[value]!;
    }
    _result.add(value);
  }

  HomogeneousTensor<T> resultHomogeneousTensor(Shape resultShape,
      {MemoryOrder? memoryOrder}) {
    if (resultShape.isScalar && _result.length == 1) {
      return ScalarTensor<T>(_result.first);
    } else if (_isSparse) {
      return SparesTensor<T>(
          _mapValue, resultShape, _sparseValue!, memoryOrder ?? MemoryOrder.c);
    } else {
      return DenseTensor<T>(_result, resultShape, memoryOrder ?? MemoryOrder.c);
    }
  }

  RaggedTensor<T> resultRaggedTensor(Shape resultShape,
      {MemoryOrder? memoryOrder}) {
    return RaggedTensor(_result, resultShape, memoryOrder ?? MemoryOrder.c);
  }
}
