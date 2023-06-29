import 'package:dtensor/dtensor.dart';
import 'package:dtensor/tensor/src/ragged_tensor.dart';

void main() {
  final c = [
    [
      [63, 9, 75, 51, 83],
      [44, 53, 57, 56, 48],
      [71, 77, 82, 91, 76],
      [67, 56, 82, 33, 74],
      [64, 76, 72, 63, 76],
      [47, 56, 49, 53, 42],
      [91, 93, 90, 88, 96],
      [61, 56, 77, 74, 74],
    ],
    [
      [0, 1, 2, 3, 4],
      [21, 53, 57, 56, 48],
      [22, 77, 82, 91, 76],
      [23, 56, 82, 33, 74],
      [24, 76, 72, 63, 76],
      [25, 56, 49, 53, 42],
      [26, 9, 90, 88, 96],
      [27, 56, 77, 74, 74],
    ],
  ];
  final f = [
    [
      [0, 1],
      [2, 3]
    ],
    [
      [4, 5],
      [6, 7]
    ]
  ];

  final t1 = DTensor<int>.tensor(c, memoryOrder: MemoryOrder.c);
  // dot(row_test_list, row_test_list);
  // print(t1.sum(axis: 0).value);

  print(DTensor<bool>.tensor(true) & DTensor<bool>.tensor(false));
}
