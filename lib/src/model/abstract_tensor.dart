import 'package:dtensor/src/helper/helper.dart';
import 'package:dtensor/src/helper/operator_helper.dart';
import 'package:dtensor/src/model/shape.dart';

import '../core/memory_order.dart';
part './dense_tensor.dart';
part './ragged_tensor.dart';
part './sparse_tensor.dart';
part './scalar_tensor.dart';

abstract class Tensor<T> {
  List<T> get tensor;
  MemoryOrder get memoryOrder;

  Shape get shape;
  T operator [](int index);

  Tensor<bool> operator &(Tensor<bool> Othet) {
    throw Exception();
  }

  Tensor<bool> operator |(Tensor<bool> Othet) {
    throw Exception();
  }

  Tensor<bool> operator ~() {
    throw Exception();
  }

  @override
  Type get runtimeType => T;

  Tensor<T> reshape(Shape s);

  dynamic get value;

  Tensor<T> transpose();

  T getRowElementByOrder(int index);
  T getColumnElementByOrder(int row);
  List<T> getAxisElements(int axis, {int? length});

  E get<E extends Object>(List<int> index);
  Tensor<num> max();
  Tensor<num> min();
  Tensor<num> mean();
  Tensor<num> mode();
  Tensor<num> average();
  Tensor<num> std();
  bool contains(T value);
}
