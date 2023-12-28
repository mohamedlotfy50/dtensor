import 'package:dtensor/const/fortran_memory_order.dart';

import '../../const/c_memory_order.dart';
import '../../const/tensor_order.dart';
import '../../model/model.dart';
import 'scalar_tensor.dart';

class SparesTensor<T extends Object> extends HomogeneousTensor<T> {
  final Shape shape;
  final Map<int, T> _value;
  final T sparesValue;
  final MemoryOrder memoryOrder;

  T operator [](int index) {
    if (index > tensor.length) {
      throw Exception();
    }
    return _value[index] ?? sparesValue;
  }

  List<T> get tensor {
    List<T> listValues = [];
    for (int i = 0; i < shape.size; i++) {
      if (_value.containsKey(i)) {
        listValues.add(_value[i]!);
      } else {
        listValues.add(sparesValue);
      }
    }
    return listValues;
  }

  SparesTensor._(this._value, this.shape, this.sparesValue, this.memoryOrder);
  factory SparesTensor(
      Map<int, T> mapValue, Shape shape, T sparse, TensorOrder tensorOrder) {
    if (tensorOrder == TensorOrder.c) {
      return SparesTensor._(mapValue, shape, sparse, CMemoryOrder());
    }
    return SparesTensor._(mapValue, shape, sparse, FortranMemoryOrder());
  }

  factory SparesTensor.zeros(Shape shape) {
    assert(T is! num);
    return SparesTensor<T>({}, shape, 0 as T, TensorOrder.c);
  }

  factory SparesTensor.ones(Shape shape) {
    assert(T is! num);
    return SparesTensor<T>({}, shape, 1 as T, TensorOrder.c);
  }

  @override
  SparesTensor<T> reshape(Shape s) {
    return SparesTensor<T>(_value, s, sparesValue, memoryOrder.order);
  }

  @override
  dynamic get value {
    if (memoryOrder is CMemoryOrder) {
      return _rowMajorReformTensor();
    }
    return _columnMajorReformTensor();
  }

  dynamic _rowMajorReformTensor() {
    dynamic current = tensor;
    dynamic temp = [];
    for (int i = shape.length - 1; i >= 0; i--) {
      for (int y = 0; y < current.length; y += shape[i]) {
        temp.add(current.sublist(y, y + shape[i]));
      }
      current = temp;
      temp = [];
    }
    return current.first;
  }

  dynamic _columnMajorReformTensor() {
    dynamic current = tensor;
    dynamic temp = [];
    for (int i = shape.length - 2; i >= 0; i--) {
      for (int y = 0; y < shape[i]; y++) {
        List row = [];
        for (int x = 0; x < shape[i + 1]; x++) {
          row.add(current[y + (shape[i] * x)]);
        }
        temp.add(row);
      }
      current = temp;
      temp = [];
    }

    return current;
  }

  @override
  SparesTensor<T> transpose() {
    return SparesTensor<T>._(
      _value,
      shape.transpose(),
      sparesValue,
      memoryOrder.transpose(),
    );
  }

  @override
  SparesTensor<T> swapAxis(int a, int b) {
    return SparesTensor<T>._(
        _value, shape.swap(a, b), sparesValue, memoryOrder);
  }

  @override
  bool contains(T value) {
    for (T element in _value.values) {
      if (value == element) {
        return true;
      }
    }

    return sparesValue == value;
  }

  @override
  SparesTensor<T> flatten() {
    return SparesTensor._(
      _value,
      Shape(shape: [shape.size], size: shape.size),
      sparesValue,
      memoryOrder,
    );
  }
}
