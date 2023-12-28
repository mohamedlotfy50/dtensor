import 'package:dtensor/dtensor.dart';
import 'package:dtensor/tensor/src/ragged_tensor.dart';
import 'package:dtensor/util/src/list_extension.dart';
import 'package:dtensor/util/src/quick_sort.dart';

void main() {
  final t1 = DTensor<int>.ones([9, 5, 7, 4]);
  final t2 = DTensor<int>.zeros([9, 5, 4, 3]);

  final stopwatch = Stopwatch()..start();

  DTensor.matMult(t1, t2);

  final s = stopwatch.elapsed;

  print('time taken  ${s}');
}
