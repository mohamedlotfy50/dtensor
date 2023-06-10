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
    return DTensor._(SparesTensor<T>.zeros(
        Shape(shape: shape, size: shape.multiply(), dimCount: [])));
  }
  factory DTensor.ones(List<int> shape) {
    return DTensor._(SparesTensor<T>.ones(
        Shape(shape: shape, size: shape.multiply(), dimCount: [])));
  }

  DTensor<T> reshape(List<int> newShape) {
    final _newShape =
        Shape(shape: newShape, size: shape.multiply(), dimCount: []);
    if (Shape.isEqual(_tensor.shape, _newShape)) {
      return DTensor._(_tensor);
    }
    return DTensor._(_tensor.reshape(_newShape));
  }

  dynamic get(List<int> index) {
    return _tensor.get(index);
  }
}
