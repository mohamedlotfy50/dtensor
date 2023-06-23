part of './abstract_tensor.dart';

class SparesTensor<T extends Object> extends Tensor<T> {
  final Shape shape;
  final Map<int, T> _value;
  final T sparesValue;
  final MemoryOrder memoryOrder;

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
    Map<int, T> value,
    Shape shape,
    T sparseValue,
    MemoryOrder memoryOrder,
  ) {
    try {
      return SparesTensor._(value, shape, sparseValue, memoryOrder);
    } catch (e) {
      throw Exception();
    }
  }

  factory SparesTensor.zeros(Shape shape) {
    return SparesTensor<T>._({}, shape, 0 as T, MemoryOrder.c);
  }

  factory SparesTensor.ones(Shape shape) {
    return SparesTensor<T>._({}, shape, 1 as T, MemoryOrder.c);
  }

  @override
  Tensor<T> reshape(Shape s) {
    return SparesTensor._(_value, s, sparesValue, memoryOrder);
  }

  @override
  E get<E extends Object>(List<int> index) {
    throw Exception();
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
  Tensor<T> transpose() {
    return SparesTensor._(
      _value,
      shape.transpose(),
      sparesValue,
      memoryOrder.transpose(),
    );
  }

  @override
  T operator [](int index) {
    if (index > tensor.length) {
      throw Exception();
    }
    return _value[index] ?? sparesValue;
  }

  @override
  T getRowElementByOrder(int index) {
    if (memoryOrder == MemoryOrder.c) {
      return _value[index] ?? sparesValue;
    }
    int currentIndex =
        (index % shape.last) * shape[shape.length - 2] + (index ~/ shape.last);
    return _value[currentIndex] ?? sparesValue;
  }

  @override
  T getColumnElementByOrder(int index) {
    if (memoryOrder == MemoryOrder.c) {
      int currentIndex = (index % shape.last) * shape[shape.length - 2] +
          (index ~/ shape.last);
      return _value[currentIndex] ?? sparesValue;
    }

    return _value[index] ?? sparesValue;
  }

  @override
  bool contains(T value) {
    if (value == sparesValue) {
      return true;
    }
    for (T val in _value.values) {
      if (val == value) {
        return true;
      }
    }
    return false;
  }

  @override
  SparesTensor<num> max() {
    if (!(T != num || T != int || T != double)) {
      throw Exception();
    }
    num maxValue = sparesValue as num;
    for (num val in _value.values as List<num>) {
      if (val > maxValue) {
        maxValue = val;
      }
    }

    return SparesTensor(
        {},
        Shape(
          shape: [1],
          size: 1,
          dimCount: [],
        ),
        maxValue,
        memoryOrder);
  }

  @override
  Tensor<num> mean() {
    // TODO: implement mean
    throw UnimplementedError();
  }

  @override
  Tensor<num> min() {
    if (!(T != num || T != int || T != double)) {
      throw Exception();
    }
    num maxValue = sparesValue as num;
    for (num val in _value.values as List<num>) {
      if (val < maxValue) {
        maxValue = val;
      }
    }

    return SparesTensor(
        {},
        Shape(
          shape: [1],
          size: 1,
          dimCount: [],
        ),
        maxValue,
        memoryOrder);
  }

  @override
  Tensor<num> mode() {
    // TODO: implement mode
    throw UnimplementedError();
  }

  @override
  Tensor<num> std() {
    // TODO: implement std
    throw UnimplementedError();
  }

  @override
  Tensor<num> average() {
    // TODO: implement average
    throw UnimplementedError();
  }

  @override
  List<T> getAxisElements(int axis) {
    // TODO: implement getAxisElements
    throw UnimplementedError();
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

    return SparesTensor(result, shape, sparseResullt, memoryOrder);
  }

  @override
  SparesTensor<num> log() {
    final Map<int, num> result = {};
    (_value as Map<int, num>).forEach((key, value) {
      result[key] = math.log(value);
    });

    return SparesTensor<num>(
        result, shape, math.log(sparesValue as num), memoryOrder);
  }

  @override
  SparesTensor<num> sign() {
    final Map<int, num> result = {};
    (_value as Map<int, num>).forEach((key, value) {
      result[key] = value.sign;
    });

    return SparesTensor<num>(
        result, shape, (sparesValue as num).sign, memoryOrder);
  }

  @override
  SparesTensor<num> sqrt() {
    final Map<int, num> result = {};
    (_value as Map<int, num>).forEach((key, value) {
      result[key] = math.sqrt(value);
    });

    return SparesTensor<num>(
        result, shape, math.sqrt(sparesValue as num), memoryOrder);
  }

  @override
  SparesTensor<T> swapAxis(int a, int b) {
    return SparesTensor<T>(_value, shape.swap(a, b), sparesValue, memoryOrder);
  }

  @override
  T getElementByAxis(int index, int axis) {
    // TODO: implement getElementByAxis
    throw UnimplementedError();
  }
}
