import 'package:dtensor/util/src/list_extension.dart';

import '../../../const/memory_order.dart';
import '../../helper/src/operator_helper.dart';
import '../../tensor/tensor.dart';
import 'base_tensor.dart';
import 'shape.dart';
import '../../util/util.dart';
part '../../extension/src/bool_homogeneous_tensor.dart';

part '../../extension/src/num_homogeneous_tensor.dart';

abstract class HomogeneousTensor<T extends Object> extends BaseTensor<T> {
  BaseTensor<T> reshape(Shape s);
  BaseTensor<T> flatten();

  HomogeneousTensor<T> swapAxis(int a, int b);
  @override
  DenseTensor<int> argSort() {
    List<int> indices = List<int>.generate(shape.size, (index) => index);

    indices.sort((a, b) => (tensor[a] as num).compareTo(tensor[b] as num));

    return DenseTensor<int>(indices, shape, memoryOrder);
  }

  @override
  T rowOrderIndexing(int index) {
    if (memoryOrder == MemoryOrder.c) {
      return tensor[index];
    }
    int currentIndex =
        (index % shape.last) * shape[shape.length - 2] + (index ~/ shape.last);
    return tensor[currentIndex];
  }

  @override
  T columnOrderIndexing(int index) {
    if (memoryOrder == MemoryOrder.c) {
      int currentIndex = (index % shape[shape.length - 2]) * shape.last +
          (index ~/ shape[shape.length - 2]);
      return tensor[currentIndex];
    }

    return tensor[index];
  }

  @override
  E getElement<E extends Object>(List<int> index) {
    throw Exception();
  }

  DenseTensor<T> axisRowElements(int index, int axis) {
    List<T> result = [];
    int count = shape.shape.multiply(start: axis + 1);
    for (int i = 0; i < count; i++) {
      result.add(rowOrderIndexing(index * count + i));
    }
    return DenseTensor<T>(result, shape.removeDim(axis), MemoryOrder.c);
  }
}
