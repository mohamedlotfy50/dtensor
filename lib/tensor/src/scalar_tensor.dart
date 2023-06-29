import '../../const/memory_order.dart';
import '../../model/model.dart';

class ScalarTensor<T extends Object> extends HomogeneousTensor<T> {
  final Shape shape = Shape(shape: [], size: 1);
  final MemoryOrder memoryOrder = MemoryOrder.c;

  final List<T> tensor;

  ScalarTensor._(this.tensor);

  factory ScalarTensor(T value) {
    return ScalarTensor<T>._([value]);
  }

  @override
  ScalarTensor<T> reshape(Shape s) {
    throw Exception();
  }

  @override
  dynamic get value {
    return tensor.first;
  }

  @override
  ScalarTensor<T> transpose() {
    return ScalarTensor<T>(tensor.first);
  }

  @override
  T rowOrderIndexing(int index) {
    return tensor.first;
  }

  @override
  T columnOrderIndexing(int row) {
    return tensor.first;
  }

  @override
  ScalarTensor<T> where(bool Function(T) condition, T Function(T) operation) {
    throw Exception();
  }

  @override
  ScalarTensor<T> swapAxis(int a, int b) {
    return ScalarTensor<T>(tensor.first);
  }

  @override
  ScalarTensor<T> flatten() {
    return ScalarTensor<T>(value);
  }
}
