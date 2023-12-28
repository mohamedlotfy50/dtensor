import 'dart:io' show File;
import 'package:dtensor/model/src/tensor_slice.dart';

import '../../exception/not_supported_for_type.dart';
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
  int get length => _tensor.shape.size;
  dynamic get value => _tensor.value;
  @override
  Type get runtimeType => _tensor.runtimeType;
  @override
  String toString() {
    return _tensor.toString();
  }

  T operator [](int index) {
    try {
      return _tensor[index];
    } catch (e) {
      throw Exception();
    }
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

  DTensor<T> get(List<int> index) {
    return DTensor._(_tensor.getElement(index));
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

  DTensor<T> slice(TensorSlice slice) {
    return DTensor<T>._(_tensor.slice(slice));
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

  DTensor<E> tensorWhere<E extends Object>(E Function(T) whereFunction) {
    return DTensor<E>._(_tensor.tensorWhere<E>(whereFunction));
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

  static DTensor<I> tensorMode<I extends Object>(DTensor<I> inputTensor,
      {int? axis, bool keepDims = false}) {
    return DTensor<I>._(
        inputTensor._tensor.mode(axis: axis, keepDims: keepDims));
  }

  DTensor<T> mode({int? axis, bool keepDims = false}) {
    return DTensor<T>._(_tensor.mode(axis: axis, keepDims: keepDims));
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

  DTensor<T> unique() {
    return DTensor<T>._(_tensor.unique());
  }

  @override
  bool any(bool Function(DTensor<T> element) test) {
    // TODO: implement any
    throw UnimplementedError();
  }

  @override
  bool contains(Object? element) {
    if (element is! T) {
      throw Exception();
    }
    return _tensor.contains(element);
  }

  @override
  DTensor<T> elementAt(int index) {
    return DTensor<T>._(ScalarTensor<T>(_tensor[index]));
  }

  @override
  bool every(bool Function(DTensor<T> element) test) {
    // TODO: implement every
    throw UnimplementedError();
  }

  // @override
  // Iterable<T> expand<T>(Iterable<T> Function(DTensor<T> element) toElements) {
  //   // TODO: implement expand
  //   throw UnimplementedError();
  // }

  @override
  // TODO: implement first
  DTensor<T> get first => DTensor._(ScalarTensor<T>(_tensor.tensor.first));

  @override
  DTensor<T> firstWhere(bool Function(DTensor<T> element) test,
      {DTensor<T> Function()? orElse}) {
    // TODO: implement firstWhere
    throw UnimplementedError();
  }

  // @override
  // T fold<T>(
  //     T initialValue, T Function(T previousValue, DTensor<T> element) combine) {
  //   // TODO: implement fold
  //   throw UnimplementedError();
  // }

  @override
  Iterable<DTensor<T>> followedBy(Iterable<DTensor<T>> other) {
    // TODO: implement followedBy
    throw UnimplementedError();
  }

  @override
  void forEach(void Function(DTensor<T> element) action) {
    // TODO: implement forEach
  }

  @override
  // TODO: implement isEmpty
  bool get isEmpty => throw UnimplementedError();

  @override
  // TODO: implement isNotEmpty
  bool get isNotEmpty => throw UnimplementedError();

  @override
  String join([String separator = ""]) {
    // TODO: implement join
    throw UnimplementedError();
  }

  @override
  // TODO: implement last
  DTensor<T> get last => DTensor._(ScalarTensor<T>(_tensor.tensor.last));

  @override
  DTensor<T> lastWhere(bool Function(DTensor<T> element) test,
      {DTensor<T> Function()? orElse}) {
    // TODO: implement lastWhere
    throw UnimplementedError();
  }

  // @override
  // Iterable<T> map<T>(T Function(DTensor<T> e) toElement) {
  //   // TODO: implement map
  //   throw UnimplementedError();
  // }

  @override
  DTensor<T> reduce(
      DTensor<T> Function(DTensor<T> value, DTensor<T> element) combine) {
    // TODO: implement reduce
    throw UnimplementedError();
  }

  @override
  // TODO: implement single
  DTensor<T> get single => throw UnimplementedError();

  @override
  DTensor<T> singleWhere(bool Function(DTensor<T> element) test,
      {DTensor<T> Function()? orElse}) {
    // TODO: implement singleWhere
    throw UnimplementedError();
  }

  @override
  Iterable<DTensor<T>> skip(int count) {
    // TODO: implement skip
    throw UnimplementedError();
  }

  @override
  Iterable<DTensor<T>> skipWhile(bool Function(DTensor<T> value) test) {
    // TODO: implement skipWhile
    throw UnimplementedError();
  }

  @override
  DTensor<T> take(int count) {
    // TODO: implement take
    throw UnimplementedError();
  }

  @override
  DTensor<T> takeWhile(bool Function(DTensor<T> value) test) {
    // TODO: implement takeWhile
    throw UnimplementedError();
  }

  @override
  List<DTensor<T>> toList({bool growable = true}) {
    throw UnimplementedError();
  }

  @override
  Set<DTensor<T>> toSet() {
    throw UnimplementedError();
  }

  @override
  DTensor<T> where(bool Function(DTensor<T> element) test) {
    // return DTensor<T>._(_tensor.where(test));
    throw Exception();
  }

  // @override
  // Iterable whereType<T>() {
  //   // TODO: implement whereType
  //   throw UnimplementedError();
  // }
}
