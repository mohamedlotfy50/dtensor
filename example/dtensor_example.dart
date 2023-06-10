import 'dart:io';

import 'package:dtensor/dtensor.dart';
import 'package:dtensor/src/model/abstract_tensor.dart';
import 'package:dtensor/src/model/shape.dart';

void main() {
  final c = [
    [63, 72, 75, 51, 83],
    [44, 53, 57, 56, 48],
    [71, 77, 82, 91, 76],
    [67, 56, 82, 33, 74],
    [64, 76, 72, 63, 76],
    [47, 56, 49, 53, 42],
    [91, 93, 90, 88, 96],
    [61, 56, 77, 74, 74],
  ];
  final f = [
    [4, 1],
    [2, 2]
  ];

  final t1 = DTensor<int>.tensor(c, memoryOrder: MemoryOrder.c);
  // final t2 = DTensor<int>.tensor(f, memoryOrder: MemoryOrder.c);

  // final t1 = DTensor<int>.ones([9, 5, 7, 4]);
  // final t2 = DTensor<int>.ones([9, 5, 4, 3]);

  print(t1.min(axis: 0, keepDims: true).value);
}
