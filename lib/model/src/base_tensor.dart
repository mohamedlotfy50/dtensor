import 'package:dtensor/model/src/tensor_slice.dart';
import 'package:dtensor/util/util.dart';

import '../../const/tensor_order.dart';
import '../../exception/not_supported_for_type.dart';
import '../../helper/helper.dart';
import '../../tensor/tensor.dart';
import 'memory_order.dart';
import 'shape.dart';
import 'homogeneous_tensor.dart';
import 'dart:math' as math;
part '../../extension/src/bool_base_tenosr.dart';
part '../../extension/src/num_base_tensor.dart';

abstract class BaseTensor<T extends Object> {
  List<T> get tensor;

  MemoryOrder get memoryOrder;

  T operator [](int index) {
    try {
      return tensor[index];
    } catch (e) {
      throw Exception();
    }
  }

  Shape get shape;

  // @override
  // Type get runtimeType => T;
  dynamic get value;

  T rowOrderIndexing(int index);
  T columnOrderIndexing(int row);
  BaseTensor<T> getElement(List<int> index);
  BaseTensor<T> getElementByTensor(BaseTensor<int> index);
  BaseTensor<T> unique() {
    Map<T, int> uniqueMap = {};
    for (T element in tensor) {
      uniqueMap[element] = 0;
    }

    return DenseTensor<T>(
        uniqueMap.keys.toList(),
        Shape(shape: [uniqueMap.length], size: uniqueMap.length),
        memoryOrder.order);
  }

  BaseTensor<T> slice(TensorSlice slice);

  BaseTensor<T> transpose();

  bool contains(T value) {
    return tensor.contains(value);
  }

  BaseTensor<E> tensorWhere<E extends Object>(E Function(T) wherefunction);
  BaseTensor<T> where(bool Function(T) wherefunction);

  BaseTensor<T> axisRowElements(int index, int axis);
  @override
  String toString() {
    return '${super.runtimeType}($value)';
  }

  BaseTensor<T> mode({int? axis, bool keepDims = false}) {
    if (this is! HomogeneousTensor<T>) {
      throw Exception();
    }
    return (this as HomogeneousTensor<T>).mode();
  }
}
