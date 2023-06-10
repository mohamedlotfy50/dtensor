part of './abstract_tensor.dart';

class DenseTensor<T extends Object> extends Tensor<T> {
  final List<T> tensor;
  final Shape shape;
  final MemoryOrder memoryOrder;

  DenseTensor(this.tensor, this.shape, this.memoryOrder);

  @override
  Tensor<T> reshape(Shape s) {
    return DenseTensor(tensor, s, memoryOrder);
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
  Tensor<T> transpose() {
    return DenseTensor(tensor, shape.transpose(), memoryOrder.transpose());
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
    if (memoryOrder == MemoryOrder.c) {
      return tensor[index];
    }

    int currentIndex =
        (index % shape.last) * shape[shape.length - 2] + (index ~/ shape.last);

    return tensor[currentIndex];
  }

  @override
  T getColumnElementByOrder(int index) {
    if (memoryOrder == MemoryOrder.c) {
      int currentIndex = (index % shape[shape.length - 2]) * shape.last +
          (index ~/ shape[shape.length - 2]);
      return tensor[currentIndex];
    }

    return tensor[index];
  }

  @override
  Tensor<num> average() {
    // TODO: implement average
    throw UnimplementedError();
  }

  @override
  bool contains(T value) {
    return tensor.contains(value);
  }

  @override
  DenseTensor<num> max() {
    if (!(T != num || T != int || T != double)) {
      throw Exception();
    }
    num? maxValue;
    for (num val in tensor as List<num>) {
      if (maxValue == null || val > maxValue) {
        maxValue = val;
      }
    }

    return DenseTensor(
        [maxValue!],
        Shape(
          shape: [1],
          size: 1,
          dimCount: [],
        ),
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
    num? maxValue;
    for (num val in tensor as List<num>) {
      if (maxValue == null || val < maxValue) {
        maxValue = val;
      }
    }

    return DenseTensor(
        [maxValue!],
        Shape(
          shape: [1],
          size: 1,
          dimCount: [],
        ),
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
  List<T> getAxisElements(int axis, {int? length}) {
    List<T> subList = [];
    int elementLength = shape.shape.multiply(start: axis);
    int step = shape.shape.multiply(start: axis + 1);
    if (length != null && length < elementLength) {
      throw Exception();
    }
    for (int i = 0; i < (length ?? elementLength); i++) {
      subList.add(tensor[(i + step) % shape[elementLength]]);
    }
    return subList;
  }
}
