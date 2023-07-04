import 'package:dtensor/dtensor.dart';
import 'package:dtensor/tensor/src/ragged_tensor.dart';
import 'package:dtensor/util/src/list_extension.dart';
import 'package:dtensor/util/src/quick_sort.dart';

void main() {
  // final t1 = DTensor<int>.ones([9, 5, 7, 4]);
  // final t2 = DTensor<int>.ones([9, 5, 4, 3]);

  final t1 = DTensor<int>.tensor([
    [
      [
        [1, 2, 3],
        [4, 5, 6]
      ],
      [
        [7, 8, 9],
        [10, 11, 12]
      ]
    ],
    [
      [
        [13, 14, 15],
        [16, 17, 18]
      ],
      [
        [19, 20, 21],
        [22, 23, 24]
      ]
    ]
  ]);
  // final t2 = DTensor<int>.tensor([
  //   [
  //     [
  //       [25, 26],
  //       [27, 28],
  //       [29, 30]
  //     ],
  //     [
  //       [31, 32],
  //       [33, 34],
  //       [35, 36]
  //     ]
  //   ],
  //   [
  //     [
  //       [37, 38],
  //       [39, 40],
  //       [41, 42]
  //     ],
  //     [
  //       [43, 44],
  //       [45, 46],
  //       [47, 48]
  //     ]
  //   ]
  // ]);

  // final t1 = DTensor<int>.tensor([2, 5, 6]);
  final t2 = DTensor<int>.tensor([5, 6, 8, 9, 10, 11, 14]);
  // dot(row_test_list, row_test_list);
  // print(t1.sum(axis: 0).value);
  // final t1 = DTensor<int>.tensor([
  //   [1, 2, 3],
  //   [4, 5, 6]
  // ]);
  // final t2 = DTensor<int>.tensor([
  //   [10, 11],
  //   [20, 21],
  //   [30, 31],
  // ]);
  // final stopwatch = Stopwatch()..start();

  // t1.dot(t2);
  // print(stopwatch.elapsed);
  final stopwatch = Stopwatch()..start();

  print(t2.variance());
  print(stopwatch.elapsed);
}
