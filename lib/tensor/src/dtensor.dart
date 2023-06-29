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

class DTensor<T extends Object> extends Iterable<DTensor<T>> {
  DTensor._(this._tensor);

  final BaseTensor<T> _tensor;

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
        TransitionTensor.fromMap(TensorIO.load<T>(file));
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
    return DTensor<num>._(tensor._tensor.sum());
  }

  DTensor<T> swapAxis(int axis1, int axis2) {
    if (_tensor is! HomogeneousTensor) {
      throw Exception();
    }

    return DTensor<T>._(
        (_tensor as HomogeneousTensor<T>).swapAxis(axis1, axis2));
  }

  @override
  Iterator<DTensor<T>> get iterator => _DtensorIterator(_tensor);
  @override
  String toString() {
    return _tensor.toString();
  }
}

class _DtensorIterator<T extends Object> extends Iterator<DTensor<T>> {
  final BaseTensor<T> _tensor;

  int _index = 0;

  _DtensorIterator(this._tensor);

  @override
  DTensor<T> get current {
    if (_tensor is ScalarTensor<T>) {
      throw Exception();
    } else if (_tensor.shape.length == 1) {
      return DTensor<T>._(ScalarTensor<T>(
        _tensor.rowOrderIndexing(_index),
      ));
    }
    return DTensor<T>._(
      _tensor.axisRowElements(_index, 0),
    );
  }

  @override
  bool moveNext() {
    _index++;

    return _index < _tensor.shape.first;
  }
}
