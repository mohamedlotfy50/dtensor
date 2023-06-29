import 'package:dtensor/util/util.dart';

import '../../../const/memory_order.dart';
import '../../helper/helper.dart';
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

  BaseTensor<T> axisRowElements(int index, int axis);
  @override
  String toString() {
    return '${super.runtimeType}($value)';
  }
}
