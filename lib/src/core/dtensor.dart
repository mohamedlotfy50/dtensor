import 'dart:io' show File;
import 'package:dtensor/src/service/tensor_io.dart';
import '../helper/helper.dart';
import '../model/model.dart';
import 'memory_order.dart';
part 'num_dtensor_extension.dart';
part 'bool_dtensor_extension.dart';

class DTensor<T extends Object> {
  DTensor._(this._tensor);

  final Tensor<T> _tensor;

  List<int> get shape => _tensor.shape.shape;
  int get size => _tensor.shape.size;
  dynamic get value => _tensor.value;
  @override
  Type get runtimeType => _tensor.runtimeType;

  DTensor<T> transpose() {
    return DTensor<T>._(_tensor.transpose());
  }

  factory DTensor.tensor(
    dynamic value, {
    MemoryOrder memoryOrder = MemoryOrder.c,
  }) {
    final Tensor<T> processedTensor = TensorHelper.autoDetectType<T>(
      value: value,
      memoryOrder: memoryOrder,
    );
    return DTensor<T>._(
      processedTensor,
    );
  }

  factory DTensor.load(File file) {
    TransitionTensor<T> transitionTensor =
        TransitionTensor.fromMap(TensorIO.load<T>(file));
    return DTensor<T>._(transitionTensor.toTensor());
  }

  factory DTensor.zeros(List<int> shape) {
    return DTensor<T>._(SparesTensor<T>.zeros(
        Shape(shape: shape, size: shape.multiply(), dimCount: [])));
  }
  factory DTensor.ones(List<int> shape) {
    return DTensor<T>._(SparesTensor<T>.ones(
        Shape(shape: shape, size: shape.multiply(), dimCount: [])));
  }

  DTensor<T> reshape(List<int> newShape) {
    final _newShape =
        Shape(shape: newShape, size: shape.multiply(), dimCount: []);
    if (Shape.isEqual(_tensor.shape, _newShape)) {
      return DTensor<T>._(_tensor);
    }
    return DTensor<T>._(_tensor.reshape(_newShape));
  }

  DTensor<T> flatten() {
    return DTensor<T>._(_tensor.reshape(
      Shape(
        shape: [size],
        size: size,
        dimCount: [],
      ),
    ));
  }

  dynamic get(List<int> index) {
    return _tensor.get(index);
  }

  DTensor<T> where(bool Function(T) condition, T Function(T) operation) {
    return DTensor<T>._(_tensor.where(condition, operation));
  }

  DTensor<T> argWhere(bool Function(T) condition) {
    throw Exception();
  }

  static DTensor<num> sign(DTensor<num> tensor) {
    return DTensor<num>._(tensor._tensor.sign());
  }

  static DTensor<num> log(DTensor<num> tensor) {
    return DTensor<num>._(tensor._tensor.log());
  }

  static DTensor<num> sqrt(DTensor<num> tensor) {
    return DTensor<num>._(tensor._tensor.sqrt());
  }

  static DTensor<num> argMax(DTensor<num> tensor) {
    throw Exception();
  }

  static DTensor<num> argMin(DTensor<num> tensor) {
    throw Exception();
  }

  static DTensor<num> argSort(DTensor<num> tensor, {int axis = 0}) {
    throw Exception();
  }

  static DTensor<num> sort(DTensor<num> tensor, {int axis = 0}) {
    throw Exception();
  }

  static DTensor<num> sum(DTensor<num> tensor, {int axis = 0}) {
    throw Exception();
  }

  DTensor<T> swapAxis(int axis1, int axis2) {
    //TODO: not working well
    return DTensor<T>._(_tensor.swapAxis(axis1, axis2));
  }

  T getByAxis(int index, int axis) {
    return _tensor.getElementByAxis(index, axis);
  }
}
