import '../../../const/memory_order.dart';
import '../../tensor/tensor.dart';
import 'shape.dart';
import 'homogeneous_tensor.dart';
import 'dart:math' as math;
part '../../extension/src/bool_base_tenosr.dart';
part '../../extension/src/num_base_tensor.dart';

abstract class BaseTensor<T extends Object> {
  List<T> get tensor;

  MemoryOrder get memoryOrder;
  T operator [](int index) {
    if (index > tensor.length) {
      throw Exception();
    }
    return tensor[index];
  }

  Shape get shape;

  // @override
  // Type get runtimeType => T;
  dynamic get value;

  T rowOrderIndexing(int index);
  T columnOrderIndexing(int row);
  E getElement<E extends Object>(List<int> index);

  BaseTensor<T> transpose();

  bool contains(T value) {
    return tensor.contains(value);
  }

  BaseTensor<int> argSort();
  BaseTensor<T> where(bool Function(T) condition, T Function(T) operation);
  ScalarTensor<T> mode() {
    Map<T, int> histogram = {};
    int maxCount = 0;
    T? modeValue;
    for (T element in tensor) {
      if (histogram[element] == null) {
        histogram[element] = 1;
      }
      histogram[element] = histogram[element]! + 1;
      if (modeValue == null || histogram[element]! > maxCount) {
        modeValue = element;
        maxCount = histogram[element]!;
      }
    }

    return ScalarTensor<T>(modeValue!);
  }

  BaseTensor<T> axisRowElements(int index, int axis);
  @override
  String toString() {
    return '${super.runtimeType}($value)';
  }
}
