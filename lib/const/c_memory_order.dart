import 'package:dtensor/const/fortran_memory_order.dart';
import 'package:dtensor/const/tensor_order.dart';
import 'package:dtensor/model/model.dart';

class CMemoryOrder extends MemoryOrder {
  @override
  int columnOrderIndexing(int index, Shape shape) {
    int column;
    if (shape.length == 1) {
      column = 1;
    } else {
      column = shape[shape.length - 2];
    }

    return (index % column) * shape.last + (index ~/ column);
  }

  @override
  int rowOrderIndexing(int index, Shape shape) {
    return index;
  }

  TensorOrder get order => TensorOrder.c;

  @override
  FortranMemoryOrder transpose() => FortranMemoryOrder();
}
