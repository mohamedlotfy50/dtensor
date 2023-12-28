import 'package:dtensor/const/c_memory_order.dart';
import 'package:dtensor/const/tensor_order.dart';
import 'package:dtensor/model/model.dart';

class FortranMemoryOrder extends MemoryOrder {
  @override
  int columnOrderIndexing(int index, Shape shape) {
    return index;
  }
  //TODO: fix this calculation

  @override
  int rowOrderIndexing(int index, Shape shape) {
    int column;
    if (shape.length == 1) {
      column = 1;
    } else {
      column = shape[shape.length - 2];
    }

    column = shape[shape.length - 2];

    return (index % shape.last) * column + (index ~/ shape.last);
  }
  //TODO add method to flatten list according to column order

  TensorOrder get order => TensorOrder.f;
  @override
  CMemoryOrder transpose() => CMemoryOrder();
}
