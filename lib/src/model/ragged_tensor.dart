part of './abstract_tensor.dart';

class RaggedTensor<T extends Object> extends Tensor<T> {
  final List<T> tensor;
  final Shape shape;
  final MemoryOrder memoryOrder;

  RaggedTensor(this.tensor, this.shape, this.memoryOrder);

  @override
  Tensor<T> reshape(Shape s) {
    return RaggedTensor(tensor, s, memoryOrder);
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

  //TODO:fix transpose

  @override
  Tensor<T> transpose() {
    return RaggedTensor(tensor, shape.transpose(), memoryOrder.transpose());
  }

  @override
  T operator [](int index) {
    if (index > tensor.length) {
      throw Exception();
    }
    return tensor[index];
  }

  @override
  T getRowElementByOrder(int index) {
    // TODO: implement getByIndex
    throw UnimplementedError();
  }

  @override
  T getColumnElementByOrder(int row) {
    // TODO: implement getColumnElementByOrder
    throw UnimplementedError();
  }

  @override
  Tensor<num> average() {
    // TODO: implement average
    throw UnimplementedError();
  }

  @override
  bool contains(T value) {
    // TODO: implement contains
    throw UnimplementedError();
  }

  @override
  Tensor<num> max() {
    // TODO: implement max
    throw UnimplementedError();
  }

  @override
  Tensor<num> mean() {
    // TODO: implement mean
    throw UnimplementedError();
  }

  @override
  Tensor<num> min() {
    // TODO: implement min
    throw UnimplementedError();
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
}
