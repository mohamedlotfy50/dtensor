import 'dart:io' show File;
import '../../model/model.dart';
import 'scalar_tensor.dart';
import 'sparse_tensor.dart';
import 'dense_tensor.dart';
import 'package:dtensor/util/util.dart';
import '../../const/memory_order.dart';
import '../../helper/helper.dart';
import '../../service/service.dart';
part '../../extension/src/bool_dtensor.dart';
part '../../extension/src/num_dtensor.dart';
part './dtensor_iterator.dart';

class DTensor<T extends Object> extends Iterable<DTensor<T>> {
  DTensor._(this._tensor);

  final BaseTensor<T> _tensor;

  List<int> get shape => _tensor.shape.shape;
  int get size => _tensor.shape.size;
  dynamic get value => _tensor.value;
  @override
  Type get runtimeType => _tensor.runtimeType;
  @override
  String toString() {
    return _tensor.toString();
  }

  @override
  Iterator<DTensor<T>> get iterator => _DtensorIterator(_tensor);

  DTensor<T> transpose() {
    return DTensor<T>._(_tensor.transpose());
  }

  factory DTensor.tensor(
    dynamic value, {
    MemoryOrder memoryOrder = MemoryOrder.c,
  }) {
    final BaseTensor<T> processedTensor = TensorHelper.autoDetectType<T>(
      value: value,
      memoryOrder: memoryOrder,
    );
    return DTensor<T>._(
      processedTensor,
    );
  }

  factory DTensor.load(File file) {
    TransitionTensor<T> transitionTensor =
        TransitionTensor<T>.fromMap(TensorIO.load<T>(file));
    return DTensor<T>._(transitionTensor.toTensor());
  }

  factory DTensor.zeros(List<int> shape) {
    return DTensor<T>._(
        SparesTensor<T>.zeros(Shape(shape: shape, size: shape.multiply())));
  }
  factory DTensor.ones(List<int> shape) {
    return DTensor<T>._(
        SparesTensor<T>.ones(Shape(shape: shape, size: shape.multiply())));
  }

  DTensor<T> reshape(List<int> newShape) {
    if (_tensor is! HomogeneousTensor) {
      throw Exception();
    }

    final _newShape = Shape(shape: newShape, size: shape.multiply());
    if (Shape.isEqual(_tensor.shape, _newShape)) {
      return DTensor<T>._(_tensor);
    }
    return DTensor<T>._((_tensor as HomogeneousTensor<T>).reshape(_newShape));
  }

  DTensor<T> flatten() {
    if (_tensor is! HomogeneousTensor) {
      throw Exception();
    }
    return DTensor<T>._((_tensor as HomogeneousTensor<T>).flatten());
  }

  dynamic get(List<int> index) {
    return _tensor.getElement(index);
  }

  factory DTensor.empty() {
    return DTensor<T>._(
      DenseTensor<T>([], Shape(shape: [], size: 0), MemoryOrder.c),
    );
  }

  void add(DTensor<T> value) {
    throw Exception();
  }

  DTensor<T> argWhere(bool Function(T) condition) {
    throw Exception();
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

  // static DTensor<num> sum(DTensor<num> tensor, {int axis = 0}) {
  //   return DTensor<num>._(tensor._tensor.sum());
  // }

  DTensor<T> swapAxis(int axis1, int axis2) {
    if (_tensor is! HomogeneousTensor) {
      throw Exception();
    }

    return DTensor<T>._(
        (_tensor as HomogeneousTensor<T>).swapAxis(axis1, axis2));
  }

  DTensor<num> dot(DTensor<num> other) {
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .dot(other._tensor as HomogeneousTensor<num>));
  }

  DTensor<num> matMult(DTensor<num> other) {
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .matMult(other._tensor as HomogeneousTensor<num>));
  }

  static DTensor<num> exp(DTensor<num> inputTensor) {
    return DTensor<num>._(inputTensor._tensor.exp());
  }

  static DTensor<num> pow(DTensor<num> inputTensor, num exponent) {
    return DTensor<num>._(inputTensor._tensor.pow(exponent));
  }

  static DTensor<num> sqrt(DTensor<num> inputTensor) {
    return DTensor._(inputTensor._tensor.sqrt());
  }

  static DTensor<num> sign(DTensor<num> inputTensor) {
    return DTensor._(inputTensor._tensor.sign());
  }

  static DTensor<num> log(DTensor<num> inputTensor) {
    return DTensor._(inputTensor._tensor.log());
  }

  static DTensor<num> max(DTensor<num> inputTensor,
      {int? axis, bool keepDims = false}) {
    if (inputTensor._tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((inputTensor._tensor as HomogeneousTensor<num>)
        .max(axis: axis, keepDims: keepDims));
  }

  static DTensor<num> min(DTensor<num> inputTensor,
      {int? axis, bool keepDims = false}) {
    if (inputTensor._tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((inputTensor._tensor as HomogeneousTensor<num>)
        .min(axis: axis, keepDims: keepDims));
  }

  static DTensor<num> sum(DTensor<num> inputTensor,
      {int? axis, bool keepDims = false}) {
    if (inputTensor._tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((inputTensor._tensor as HomogeneousTensor<num>)
        .sum(axis: axis, keepDims: keepDims));
  }

  static DTensor<num> mean(DTensor<num> inputTensor,
      {int? axis, bool keepDims = false}) {
    if (inputTensor._tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((inputTensor._tensor as HomogeneousTensor<num>)
        .mean(axis: axis, keepDims: keepDims));
  }

  static DTensor<I> mode<I extends Object>(DTensor<I> inputTensor,
      {int? axis, bool keepDims = false}) {
    if (inputTensor._tensor is! HomogeneousTensor<I>) {
      throw Exception();
    }
    return DTensor<I>._((inputTensor._tensor as HomogeneousTensor<I>)
        .mode(axis: axis, keepDims: keepDims));
  }

  static DTensor<num> median(DTensor<num> inputTensor,
      {int? axis, bool keepDims = false}) {
    if (inputTensor._tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }

    return DTensor<num>._((inputTensor._tensor as HomogeneousTensor<num>)
        .median(axis: axis, keepDims: keepDims));
  }
}
