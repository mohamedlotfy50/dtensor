import 'package:dtensor/const/fortran_memory_order.dart';
import 'package:dtensor/const/tensor_order.dart';
import 'package:dtensor/model/model.dart';

class CMemoryOrder extends MemoryOrder {
  //TODO: fix this calculation
  @override
  int columnOrderIndexing(int index, Shape shape) {
    int column;
    if (shape.length == 1) {
      column = 1;
    } else {
      column = shape[shape.length - 2];
    }

    column = shape[shape.length - 2];

    return (index % column) * shape.last + (index ~/ column);
  }

  @override
  int rowOrderIndexing(int index, Shape shape) {
    return index;
  }
  //TODO add method to flatten list according to c order

  TensorOrder get order => TensorOrder.c;

  @override
  FortranMemoryOrder transpose() => FortranMemoryOrder();
}
