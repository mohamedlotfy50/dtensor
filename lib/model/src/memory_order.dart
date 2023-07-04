import 'package:dtensor/const/tensor_order.dart';
import 'package:dtensor/model/src/shape.dart';

abstract class MemoryOrder {
  TensorOrder get order;
  int rowOrderIndexing(int index, Shape shape);
  int columnOrderIndexing(int index, Shape shape);
  MemoryOrder transpose();
}
