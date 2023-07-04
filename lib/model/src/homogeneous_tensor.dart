import 'package:dtensor/util/src/list_extension.dart';
import 'dart:math' as math;
import '../../const/tensor_order.dart';
import '../../helper/src/operator_helper.dart';
import '../../tensor/tensor.dart';
import '../../util/src/quick_sort.dart';
import 'base_tensor.dart';
import 'shape.dart';
import '../../util/util.dart';
part '../../extension/src/bool_homogeneous_tensor.dart';

part '../../extension/src/num_homogeneous_tensor.dart';

abstract class HomogeneousTensor<T extends Object> extends BaseTensor<T> {
  BaseTensor<T> reshape(Shape s);
  BaseTensor<T> flatten();

  @override
  E getElementByTensor<E extends Object>(BaseTensor<int> index) {
    throw Exception();
  }

  HomogeneousTensor<T> swapAxis(int a, int b);

  @override
  T rowOrderIndexing(int index) {
    int currentIndex = memoryOrder.rowOrderIndexing(index, shape);
    return tensor[currentIndex];
  }

  @override
  T columnOrderIndexing(int index) {
    int currentIndex = memoryOrder.columnOrderIndexing(index, shape);
    return tensor[currentIndex];
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
    return DenseTensor<T>(result, shape.removeDim(axis), TensorOrder.c);
  }

  BaseTensor<T> mode({int? axis, bool keepDims = false}) {
    if (axis == null) {
      if (this is SparesTensor<num>) {
        return ScalarTensor<T>((this as SparesTensor<T>).sparesValue);
      }
      Map<T, int> histogram = {};
      int maxCount = 0;
      T? modeValue;
      for (T element in tensor) {
        if (histogram[element] == null) {
          histogram[element] = 1;
        }
        histogram[element] = histogram[element]! + 1;
        if (modeValue == null || histogram[element]! > maxCount) {
          modeValue = element;
          maxCount = histogram[element]!;
        }
      }

      return ScalarTensor<T>(modeValue!);
    } else if (axis >= 0 && axis < shape.length) {
      late final Shape resultShape;
      if (keepDims) {
        resultShape = shape.replaceDim(axis, 1);
      } else {
        resultShape = shape.removeDim(axis);
      }
      OperatorHelper<T> operatorHelper = OperatorHelper<T>();

      int externlLoop = shape.shape.multiply(exclude: axis);
      int innerDimensions = shape.shape.multiply(start: axis + 1);
      int jump = shape.shape.multiply(start: axis);
      Map<T, int> histogram = {};
      int maxCount = 0;
      T? modeValue;
      for (int i = 0; i < externlLoop; i++) {
        for (int y = 0; y < shape[axis]; y++) {
          int factor = i ~/ innerDimensions;
          int location = i % innerDimensions;
          int pointer = location + factor * jump;

          T val = rowOrderIndexing(pointer + (y * innerDimensions));
          if (histogram[val] == null) {
            histogram[val] = 1;
          }
          histogram[val] = histogram[val]! + 1;
          if (modeValue == null || histogram[val]! > maxCount) {
            modeValue = val;
            maxCount = histogram[val]!;
          }
        }

        operatorHelper.addResult(modeValue!);
      }

      return operatorHelper.resultHomogeneousTensor(resultShape);
    } else {
      throw Exception();
    }
  }
}
