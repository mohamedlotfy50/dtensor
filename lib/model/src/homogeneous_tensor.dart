import 'package:dtensor/model/src/tensor_slice.dart';
import 'package:dtensor/util/src/list_extension.dart';
import 'dart:math' as math;
import '../../const/tensor_order.dart';
import '../../exception/broadcast_exception.dart';
import '../../exception/not_supported_for_type.dart';
import '../../exception/range_exception.dart';
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
  BaseTensor<T> getElementByTensor(BaseTensor<int> index) {
    try {
      OperatorHelper<T> operatorHelper = OperatorHelper<T>();

      for (int i in index.tensor) {
        operatorHelper.addResult(tensor[i]);
      }

      return operatorHelper.resultHomogeneousTensor(index.shape);
    } catch (e) {
      throw RangeException('index', 0, tensor.length);
    }
  }

  HomogeneousTensor<T> swapAxis(int a, int b);

  @override
  T rowOrderIndexing(int index) {
    int currentIndex = memoryOrder.rowOrderIndexing(index, shape);
    return tensor[currentIndex];
  }

  @override
  HomogeneousTensor<T> where(bool Function(T) wherefunction) {
    OperatorHelper<T> operatorHelper = OperatorHelper<T>();

    for (T element in tensor) {
      if (wherefunction(element)) {
        operatorHelper.addResult(element);
      }
    }
    return operatorHelper.resultHomogeneousTensor(shape);
  }

  @override
  HomogeneousTensor<E> tensorWhere<E extends Object>(
      E Function(T) wherefunction) {
    OperatorHelper<E> operatorHelper = OperatorHelper<E>();

    for (T element in tensor) {
      operatorHelper.addResult(wherefunction(element));
    }
    return operatorHelper.resultHomogeneousTensor(shape);
  }

  @override
  T columnOrderIndexing(int index) {
    int currentIndex = memoryOrder.columnOrderIndexing(index, shape);
    return tensor[currentIndex];
  }

  @override
  HomogeneousTensor<T> getElement(List<int> index) {
    throw Exception();
  }

  HomogeneousTensor<T> slice(TensorSlice slice) {
    TensorSlice? currentSlice = slice;
    final List<T> result = [];
    while (currentSlice != null) {
      currentSlice = currentSlice.slice;
    }
    throw Exception();
//     if (step > shape.length) {
//       throw RangeException('subTensor', step, shape.length);
//     }
//     if (end > shape[step] || start > shape[step] - 1 || start < 0) {
//       throw RangeException('subTensor', 0, shape.length);
//     }
// //TODO: fix the step
//     final int size = shape.shape.multiply(start: step + 1);
//     final int step = shape.shape.multiply(start: step);
//     final int elementSizeOutFirst = ((end * size) - (start * size)) ~/ size;

//     final int startIndex = start * size;
//     final int endIndex = startIndex + elementSizeOutFirst * size;

//     OperatorHelper<T> operatorHelper = OperatorHelper<T>();

//     for (int i = startIndex; i < endIndex; i++) {
//       operatorHelper.addResult(rowOrderIndexing(i));
//     }
//     List<int> resultShape = [];
//     if (elementSizeOutFirst > 1) {
//       resultShape.add(elementSizeOutFirst);
//     }

//     for (int i = 1; i < shape.length; i++) {
//       resultShape.add(shape[i]);
//     }
//     return operatorHelper
//         .resultHomogeneousTensor(Shape(shape: resultShape, size: size));
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
    }
    if (axis < 0 || axis > shape.length) {
      throw RangeException('axis', 0, shape.length);
    }
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
  }
}
