import '../../const/memory_order.dart';
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

  SparesTensor(this._value, this.shape, this.sparesValue, this.memoryOrder);

  factory SparesTensor.zeros(Shape shape) {
    assert(T is! num);
    return SparesTensor<T>({}, shape, 0 as T, MemoryOrder.c);
  }

  factory SparesTensor.ones(Shape shape) {
    assert(T is! num);
    return SparesTensor<T>({}, shape, 1 as T, MemoryOrder.c);
  }

  @override
  SparesTensor<T> reshape(Shape s) {
    return SparesTensor<T>(_value, s, sparesValue, memoryOrder);
  }

  @override
  dynamic get value {
    switch (memoryOrder) {
      case MemoryOrder.c:
        return _rowMajorReformTensor();
      case MemoryOrder.f:
        return _columnMajorReformTensor();
    }
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
    return SparesTensor<T>(
      _value,
      shape.transpose(),
      sparesValue,
      memoryOrder.transpose(),
    );
  }

  @override
  SparesTensor<T> where(bool Function(T) condition, T Function(T) operation) {
    Map<int, T> result = {};
    T sparseResullt =
        condition(sparesValue) ? operation(sparesValue) : sparesValue;

    _value.forEach((key, value) {
      if (condition(value)) {
        result[key] = operation(value);
      } else {
        result[key] = value;
      }
    });

    return SparesTensor<T>(result, shape, sparseResullt, memoryOrder);
  }

  @override
  SparesTensor<T> swapAxis(int a, int b) {
    return SparesTensor<T>(_value, shape.swap(a, b), sparesValue, memoryOrder);
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
    return SparesTensor(
      _value,
      Shape(shape: [shape.size], size: shape.size),
      sparesValue,
      memoryOrder,
    );
  }
}
