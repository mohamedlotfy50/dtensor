import 'package:dtensor/const/c_memory_order.dart';
import 'package:dtensor/const/fortran_memory_order.dart';

import '../../const/tensor_order.dart';
import '../../model/model.dart';

class DenseTensor<T extends Object> extends HomogeneousTensor<T> {
  final List<T> tensor;
  final Shape shape;
  final MemoryOrder memoryOrder;

  DenseTensor._(this.tensor, this.shape, this.memoryOrder);

  factory DenseTensor(
      List<T> flatTensor, Shape shape, TensorOrder tensorOrder) {
    if (tensorOrder == TensorOrder.c) {
      return DenseTensor._(flatTensor, shape, CMemoryOrder());
    }
    return DenseTensor._(flatTensor, shape, FortranMemoryOrder());
  }

  @override
  HomogeneousTensor<T> reshape(Shape s) {
    return DenseTensor._(tensor, s, memoryOrder);
  }

  @override
  dynamic get value {
    if (memoryOrder is CMemoryOrder) {
      return _rowMajorReformTensor();
    }
    return _columnMajorReformTensor();
  }

  dynamic _rowMajorReformTensor() {
    if (shape.isEmpty) {
      return [];
    }
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
  DenseTensor<T> transpose() {
    return DenseTensor._(tensor, shape.transpose(), memoryOrder.transpose());
  }

  @override
  DenseTensor<T> swapAxis(int a, int b) {
    return DenseTensor<T>._(tensor, shape.swap(a, b), memoryOrder);
  }

  @override
  DenseTensor<T> flatten() {
    return DenseTensor<T>._(
      tensor,
      Shape(shape: [shape.size], size: shape.size),
      memoryOrder,
    );
  }

  static DenseTensor<int> arange(int start, int end, int step) {
    if (start < 0 || end < 0 || step < 0) {
      throw Exception();
    }
    int length = ((end - start) / step).round();
    List<int> tensorList =
        List<int>.generate(length, (index) => start + index * step);
    return DenseTensor<int>(
        tensorList,
        Shape(shape: [tensorList.length], size: tensorList.length),
        TensorOrder.c);
  }

  static DenseTensor<double> linspace(int start, int end, int delta) {
    double incrementCount = (end - start) / delta;
    List<double> tensorList = List<double>.generate(
        delta + 1, (index) => start + index * incrementCount);
    return DenseTensor<double>(
        tensorList,
        Shape(shape: [tensorList.length], size: tensorList.length),
        TensorOrder.c);
  }
}
