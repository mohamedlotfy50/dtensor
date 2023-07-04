import 'dart:io' show File;
import '../../model/model.dart';
import 'scalar_tensor.dart';
import 'sparse_tensor.dart';
import 'dense_tensor.dart';
import 'package:dtensor/util/util.dart';
import '../../const/tensor_order.dart';
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
    TensorOrder tensorOrder = TensorOrder.c,
  }) {
    final BaseTensor<T> processedTensor = TensorHelper.autoDetectType<T>(
      value: value,
      tensorOrder: tensorOrder,
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

  static DTensor<int> arange({int start = 0, required int end, int step = 1}) {
    return DTensor<int>._(DenseTensor.arange(start, end, step));
  }

  static DTensor<double> linspace(int start, int end, int delta) {
    return DTensor<double>._(DenseTensor.linspace(start, end, delta));
  }

  dynamic get(List<int> index) {
    return _tensor.getElement(index);
  }

  dynamic getFromDtensor(DTensor<int> index) {
    return _tensor.getElementByTensor(index._tensor);
  }

  factory DTensor.empty(List<int> shape) {
    return DTensor<T>._(
      DenseTensor<T>([], Shape(shape: shape, size: 0), TensorOrder.c),
    );
  }

  void add(DTensor<T> value) {
    throw Exception();
  }

  DTensor<T> argWhere(bool Function(T) condition) {
    throw Exception();
  }

  DTensor<T> subTensor({int start = 0, required int end}) {
    throw Exception();
  }

  static DTensor<num> argMax(DTensor<num> tensor,
      {int? axis, bool keepDims = false}) {
    return tensor.argMax(axis: axis, keepDims: keepDims);
  }

  static DTensor<num> argMin(DTensor<num> tensor,
      {int? axis, bool keepDims = false}) {
    return tensor.argMin(axis: axis, keepDims: keepDims);
  }

  static DTensor<int> argSort(DTensor<num> tensor,
      {int axis = 0, bool keepDims = false}) {
    return tensor.argSort(axis: axis, keepDims: keepDims);
  }

  static DTensor<num> sort(DTensor<num> tensor,
      {int axis = 0, bool keepDims = false}) {
    return tensor.sort(axis: axis, keepDims: keepDims);
  }

  DTensor<T> swapAxis(int axis1, int axis2) {
    if (_tensor is! HomogeneousTensor) {
      throw Exception();
    }

    return DTensor<T>._(
        (_tensor as HomogeneousTensor<T>).swapAxis(axis1, axis2));
  }

  static DTensor<num> dot(DTensor<num> first, DTensor<num> second) {
    return first.dot(second);
  }

  static DTensor<num> matMult(DTensor<num> first, DTensor<num> second) {
    return first.matMult(second);
  }

  static DTensor<num> exp(DTensor<num> inputTensor) {
    return inputTensor.exp();
  }

  static DTensor<num> pow(DTensor<num> inputTensor, num exponent) {
    return inputTensor.pow(exponent);
  }

  static DTensor<num> sqrt(DTensor<num> inputTensor) {
    return inputTensor.sqrt();
  }

  static DTensor<num> sign(DTensor<num> inputTensor) {
    return inputTensor.sign();
  }

  static DTensor<num> log(DTensor<num> inputTensor) {
    return inputTensor.log();
  }

  static DTensor<num> max(DTensor<num> inputTensor,
      {int? axis, bool keepDims = false}) {
    return inputTensor.max(axis: axis, keepDims: keepDims);
  }

  static DTensor<num> min(DTensor<num> inputTensor,
      {int? axis, bool keepDims = false}) {
    return inputTensor.min(axis: axis, keepDims: keepDims);
  }

  static DTensor<num> sum(DTensor<num> inputTensor,
      {int? axis, bool keepDims = false}) {
    return inputTensor.sum(axis: axis, keepDims: keepDims);
  }

  static DTensor<num> mean(DTensor<num> inputTensor,
      {int? axis, bool keepDims = false}) {
    return inputTensor.mean(axis: axis, keepDims: keepDims);
  }

  static DTensor<I> mode<I extends Object>(DTensor<I> inputTensor,
      {int? axis, bool keepDims = false}) {
    return DTensor<I>._(
        inputTensor._tensor.mode(axis: axis, keepDims: keepDims));
  }

  static DTensor<num> median(DTensor<num> inputTensor,
      {int? axis, bool keepDims = false}) {
    return inputTensor.median(axis: axis, keepDims: keepDims);
  }

  static DTensor<num> maximum(DTensor<num> first, DTensor<num> second) {
    return first.maximum(second);
  }

  static DTensor<num> minimum(DTensor<num> first, DTensor<num> second) {
    return first.minimum(second);
  }
}
