import 'package:dtensor/const/c_memory_order.dart';
import 'package:dtensor/const/fortran_memory_order.dart';
import 'package:dtensor/tensor/src/dense_tensor.dart';

import '../../const/tensor_order.dart';
import '../../model/model.dart';

class RaggedTensor<T extends Object> extends BaseTensor<T> {
  final List<T> tensor;
  final Shape shape;
  final MemoryOrder memoryOrder;

  RaggedTensor._(this.tensor, this.shape, this.memoryOrder);
  factory RaggedTensor(
      List<T> flatTensor, Shape shape, TensorOrder tensorOrder) {
    if (tensorOrder == TensorOrder.c) {
      return RaggedTensor._(flatTensor, shape, CMemoryOrder());
    }
    return RaggedTensor._(flatTensor, shape, FortranMemoryOrder());
  }

  @override
  E getElement<E extends Object>(List<int> index) {
    throw Exception();
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
    int start = 0;
    for (int i = shape.dimCount.length - 1; i >= 0; i--) {
      for (int len in shape.dimCount[i]) {
        if (len > 0) {
          temp.add(current.sublist(start, start + len));
          start += len;
        } else {
          temp.add([]);
        }
      }
      current = temp;
      temp = [];
      start = 0;
    }
    return current;
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
  RaggedTensor<T> transpose() {
    return RaggedTensor<T>._(
        tensor, shape.transpose(), memoryOrder.transpose());
  }

  @override
  RaggedTensor<T> where(bool Function(T) condition, T Function(T) operation) {
    List<T> result = [];

    for (T element in tensor) {
      if (condition(element)) {
        result.add(operation(element));
      } else {
        result.add(element);
      }
    }

    return RaggedTensor<T>._(result, shape, memoryOrder);
  }

  @override
  BaseTensor<int> argSort() {
    // TODO: implement argSort
    throw UnimplementedError();
  }

  @override
  T columnOrderIndexing(int row) {
    // TODO: implement columnOrderIndexing
    throw UnimplementedError();
  }

  @override
  T rowOrderIndexing(int index) {
    // TODO: implement rowOrderIndexing
    throw UnimplementedError();
  }

  @override
  BaseTensor<T> axisRowElements(int index, int axis) {
    // TODO: implement axisRowElements
    throw UnimplementedError();
  }

  @override
  DenseTensor<T> flatten() {
    return DenseTensor<T>(tensor, Shape(shape: [shape.size], size: shape.size),
        memoryOrder.order);
  }

  @override
  getElementByTensor<E extends Object>(BaseTensor<int> index) {
    // TODO: implement getElementByTensor
    throw UnimplementedError();
  }
}
