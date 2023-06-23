part of './abstract_tensor.dart';

class ScalarTensor<T extends Object> extends Tensor<T> {
  final Shape shape = Shape(
    shape: [],
    size: 1,
    dimCount: [],
  );
  final MemoryOrder memoryOrder = MemoryOrder.c;

  final List<T> tensor;

  ScalarTensor._(this.tensor);

  factory ScalarTensor(T value) {
    return ScalarTensor<T>._([value]);
  }

  @override
  Tensor<T> reshape(Shape s) {
    throw Exception();
  }

  @override
  E get<E extends Object>(List<int> index) {
    throw Exception();
  }

  @override
  dynamic get value {
    return tensor.first;
  }

  @override
  Tensor<T> transpose() {
    throw Exception();
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
    return tensor.first;
  }

  @override
  T getColumnElementByOrder(int row) {
    return tensor.first;
  }

  @override
  bool contains(T value) {
    return value == tensor.first;
  }

  @override
  ScalarTensor<num> average() {
    return ScalarTensor<num>(value);
  }

  @override
  ScalarTensor<num> max() {
    return ScalarTensor<num>(value);
  }

  @override
  ScalarTensor<num> mean() {
    return ScalarTensor<num>(value);
  }

  @override
  ScalarTensor<num> min() {
    return ScalarTensor<num>(value);
  }

  @override
  ScalarTensor<num> mode() {
    return ScalarTensor<num>(value);
  }

  @override
  ScalarTensor<num> std() {
    return ScalarTensor<num>(value);
  }

  @override
  List<T> getAxisElements(int axis) {
    // TODO: implement getAxisElements
    throw UnimplementedError();
  }

  @override
  DenseTensor<T> where(bool Function(T) condition, T Function(T) operation) {
    throw Exception();
  }

  @override
  ScalarTensor<num> log() {
    return ScalarTensor<num>(math.log(tensor.first as num));
  }

  @override
  ScalarTensor<num> sign() {
    return ScalarTensor<num>((tensor.first as num).sign);
  }

  @override
  ScalarTensor<num> sqrt() {
    return ScalarTensor<num>(math.sqrt(tensor.first as num));
  }

  @override
  ScalarTensor<T> swapAxis(int a, int b) {
    return ScalarTensor<T>(tensor.first);
  }

  @override
  T getElementByAxis(int index, int axis) {
    // TODO: implement getElementByAxis
    throw UnimplementedError();
  }
}
