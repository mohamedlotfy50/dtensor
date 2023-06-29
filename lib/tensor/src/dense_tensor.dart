import '../../const/memory_order.dart';
import '../../model/model.dart';

class DenseTensor<T extends Object> extends HomogeneousTensor<T> {
  final List<T> tensor;
  final Shape shape;
  final MemoryOrder memoryOrder;

  DenseTensor(this.tensor, this.shape, this.memoryOrder);

  @override
  HomogeneousTensor<T> reshape(Shape s) {
    return DenseTensor(tensor, s, memoryOrder);
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
    return DenseTensor(tensor, shape.transpose(), memoryOrder.transpose());
  }

  @override
  DenseTensor<T> where(bool Function(T) condition, T Function(T) operation) {
    List<T> result = [];

    for (T element in tensor) {
      if (condition(element)) {
        result.add(operation(element));
      } else {
        result.add(element);
      }
    }

    return DenseTensor<T>(result, shape, memoryOrder);
  }

  @override
  DenseTensor<T> swapAxis(int a, int b) {
    return DenseTensor<T>(tensor, shape.swap(a, b), memoryOrder);
  }

  @override
  DenseTensor<T> flatten() {
    return DenseTensor<T>(
      tensor,
      Shape(shape: [shape.size], size: shape.size),
      memoryOrder,
    );
  }
}
