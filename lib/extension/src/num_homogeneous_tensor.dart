part of '../../model/src/homogeneous_tensor.dart';

extension NumHomogeneousTensor on HomogeneousTensor<num> {
  HomogeneousTensor<num> homogeneousAdd(HomogeneousTensor<num> other) {
    final Shape? resultShape = Shape.tryBroadcast(shape, other.shape);
    if (resultShape == null) {
      throw BroadcastException(shape, other.shape);
    }

    if (this is ScalarTensor<num> && other is ScalarTensor<num>) {
      return ScalarTensor<num>(tensor.first + other.tensor.first);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      num value = rowOrderIndexing(i % shape.size) +
          other.rowOrderIndexing(i % other.shape.size);

      operatorHelper.addResult(value);
      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> homogeneousSubtract(HomogeneousTensor<num> other) {
    final Shape? resultShape = Shape.tryBroadcast(shape, other.shape);
    if (resultShape == null) {
      throw BroadcastException(shape, other.shape);
    }

    if (this is ScalarTensor<num> && other is ScalarTensor<num>) {
      return ScalarTensor<num>(tensor.first - other.tensor.first);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      num value = rowOrderIndexing(i % shape.size) -
          other.rowOrderIndexing(i % other.shape.size);

      operatorHelper.addResult(value);
      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> homogeneousMultiply(HomogeneousTensor<num> other) {
    final Shape? resultShape = Shape.tryBroadcast(shape, other.shape);
    if (resultShape == null) {
      throw BroadcastException(shape, other.shape);
    }

    if (this is ScalarTensor<num> && other is ScalarTensor<num>) {
      return ScalarTensor<num>(tensor.first * other.tensor.first);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      num value = rowOrderIndexing(i % shape.size) *
          other.rowOrderIndexing(i % other.shape.size);

      operatorHelper.addResult(value);
      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> homogeneousDivid(HomogeneousTensor<num> other) {
    final Shape? resultShape = Shape.tryBroadcast(shape, other.shape);
    if (resultShape == null) {
      throw BroadcastException(shape, other.shape);
    }

    if (this is ScalarTensor<num> && other is ScalarTensor<num>) {
      return ScalarTensor<num>(tensor.first / other.tensor.first);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      num value = rowOrderIndexing(i % shape.size) /
          other.rowOrderIndexing(i % other.shape.size);

      operatorHelper.addResult(value);
      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> dot(HomogeneousTensor<num> other) {
    if (this is ScalarTensor<num> || other is ScalarTensor<num>) {
      return ScalarTensor<num>(tensor.first * other.tensor.first);
    } else if (shape.length == 2 && other.shape.length == 2) {
      return this.matMult(other);
    }
    final Shape? resultShape = Shape.dot(this.shape, other.shape);

    if (resultShape == null) {
      throw BroadcastException(shape, other.shape);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    late final int externalLoops;
    late final int internalLoop;

    if (shape.length == 1) {
      externalLoops = 1;
    } else {
      externalLoops = shape.shape.multiply(end: shape.length - 1);
    }
    final int last = shape.last;

    if (other.shape.length == 1) {
      internalLoop = 1;
    } else {
      internalLoop = other.shape.shape.multiply(exclude: shape.length - 2);
    }
    for (int dim = 0; dim < externalLoops; dim++) {
      int startFirstMatrix = dim * last;

      for (int col = 0; col < internalLoop; col++) {
        num total = 0;
        int startSecondMatrix = col * last;

        for (int i = 0; i < last; i++) {
          num r = rowOrderIndexing(startFirstMatrix + i);
          num c = other.columnOrderIndexing(startSecondMatrix + i);
          total += r * c;
        }

        operatorHelper.addResult(total);
      }
    }

    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> matMult(HomogeneousTensor<num> other) {
    if (this is ScalarTensor<num> || other is ScalarTensor<num>) {
      throw NotSupportedOperationType('matMult', this);
    }
    final Shape? resultShape = Shape.matMult(this.shape, other.shape);

    if (resultShape == null) {
      throw BroadcastException(shape, other.shape);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    late final int externalLoops;
    late final int internalDim;
    late final int columns;
    if (shape.length == 1) {
      externalLoops = 1;
      internalDim = shape.last;
      columns = 1;
    } else {
      externalLoops = shape.shape.multiply(end: shape.length - 2);
      internalDim = shape.shape.multiply(start: shape.length - 2);
      columns = shape[shape.length - 2];
    }

    for (int dim = 0; dim < externalLoops; dim++) {
      for (int row = 0; row < columns; row++) {
        int startFirstMatrix = dim * internalDim + row * shape.last;

        for (int col = 0; col < columns; col++) {
          num total = 0;
          int startSecondMatrix = dim * internalDim + col * shape.last;
          for (int i = 0; i < shape.last; i++) {
            // print(startSecondMatrix);
            num r = rowOrderIndexing(startFirstMatrix + i);
            num c = other.columnOrderIndexing(startSecondMatrix + i);
            total += r * c;
          }

          operatorHelper.addResult(total);
        }
      }
    }

    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> max({int? axis, bool keepDims = false}) {
    if (axis == null) {
      num? maxValue;
      for (num element in tensor) {
        if (maxValue == null || element > maxValue) {
          maxValue = element;
        }
      }
      return ScalarTensor<num>(maxValue!);
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
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    int externlLoop = shape.shape.multiply(exclude: axis);
    int innerDimensions = shape.shape.multiply(start: axis + 1);
    int jump = shape.shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      num? resultValue;
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = rowOrderIndexing(pointer + (y * innerDimensions));
        if (resultValue == null || val > resultValue) {
          resultValue = val;
        }
      }
      operatorHelper.addResult(resultValue!);
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<int> argMax({int? axis, bool keepDims = false}) {
    if (axis == null) {
      num? maxValue;
      int? index;
      for (int i = 0; i < tensor.length; i++) {
        if (maxValue == null || tensor[i] > maxValue) {
          maxValue = tensor[i];
          index = i;
        }
      }
      return ScalarTensor<int>(index!);
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
    OperatorHelper<int> operatorHelper = OperatorHelper<int>();

    int externlLoop = shape.shape.multiply(exclude: axis);
    int innerDimensions = shape.shape.multiply(start: axis + 1);
    int jump = shape.shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      num? resultValue;
      int? index;
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = rowOrderIndexing(pointer + (y * innerDimensions));
        if (resultValue == null || val > resultValue) {
          resultValue = val;
          index = i;
        }
      }
      operatorHelper.addResult(index!);
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> min({int? axis, bool keepDims = false}) {
    if (axis == null) {
      num? maxValue;
      for (num element in tensor) {
        if (maxValue == null || element < maxValue) {
          maxValue = element;
        }
      }
      return ScalarTensor<num>(maxValue!);
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
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    int externlLoop = shape.shape.multiply(exclude: axis);
    int innerDimensions = shape.shape.multiply(start: axis + 1);
    int jump = shape.shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      num? resultValue;
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = rowOrderIndexing(pointer + (y * innerDimensions));
        if (resultValue == null || val < resultValue) {
          resultValue = val;
        }
      }
      operatorHelper.addResult(resultValue!);
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<int> argMin({int? axis, bool keepDims = false}) {
    if (axis == null) {
      num? maxValue;
      int? index;
      for (int i = 0; i < tensor.length; i++) {
        if (maxValue == null || tensor[i] < maxValue) {
          maxValue = tensor[i];
          index = i;
        }
      }
      return ScalarTensor<int>(index!);
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
    OperatorHelper<int> operatorHelper = OperatorHelper<int>();

    int externlLoop = shape.shape.multiply(exclude: axis);
    int innerDimensions = shape.shape.multiply(start: axis + 1);
    int jump = shape.shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      num? resultValue;
      int? index;
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = rowOrderIndexing(pointer + (y * innerDimensions));
        if (resultValue == null || val < resultValue) {
          resultValue = val;
          index = i;
        }
      }
      operatorHelper.addResult(index!);
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> sum({int? axis, bool keepDims = false}) {
    if (axis == null) {
      num maxValue = 0;
      for (num element in tensor) {
        maxValue += element;
      }
      return ScalarTensor<num>(maxValue);
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
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    int externlLoop = shape.shape.multiply(exclude: axis);
    int innerDimensions = shape.shape.multiply(start: axis + 1);
    int jump = shape.shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      num resultValue = 0;
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = rowOrderIndexing(pointer + (y * innerDimensions));
        resultValue += val;
      }
      operatorHelper.addResult(resultValue);
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> mean({int? axis, bool keepDims = false}) {
    if (axis == null) {
      num maxValue = 0;
      for (num element in tensor) {
        maxValue += element;
      }
      return ScalarTensor<num>(maxValue / tensor.length);
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
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    int externlLoop = shape.shape.multiply(exclude: axis);
    int innerDimensions = shape.shape.multiply(start: axis + 1);
    int jump = shape.shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      num resultValue = 0;
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = rowOrderIndexing(pointer + (y * innerDimensions));
        resultValue += val;
      }
      operatorHelper.addResult(resultValue / shape[axis]);
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> median({int? axis, bool keepDims = false}) {
    if (axis == null) {
      List<num> tensorCopy = List<num>.from(tensor);
      tensorCopy.sort();
      double center = shape.size / 2;
      num first = tensorCopy[center.floor()];
      num second = tensorCopy[center.ceil()];
      return ScalarTensor<num>((first + second) / 2);
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
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    int externlLoop = shape.shape.multiply(exclude: axis);
    int innerDimensions = shape.shape.multiply(start: axis + 1);
    int jump = shape.shape.multiply(start: axis);
    List<num> orderedList = [];
    for (int i = 0; i < externlLoop; i++) {
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = rowOrderIndexing(pointer + (y * innerDimensions));
        orderedList.add(val);
      }
      double center = shape[axis] / 2;
      num first = orderedList[center.floor()];
      num second = orderedList[center.ceil()];
      operatorHelper.addResult((first + second) / 2);
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  BaseTensor<num> std({int? axis, bool keepDims = false}) {
    if (axis == null) {
      num meanValue = 0;

      for (num element in tensor) {
        meanValue += element;
      }
      meanValue /= tensor.length;
      num sumation = 0;

      for (num element in tensor) {
        sumation += math.pow(element - meanValue, 2);
      }

      return ScalarTensor<num>(math.sqrt(sumation / (tensor.length - 1)));
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
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    int externlLoop = shape.shape.multiply(exclude: axis);
    int innerDimensions = shape.shape.multiply(start: axis + 1);
    int jump = shape.shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      num meanValue = 0;
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = rowOrderIndexing(pointer + (y * innerDimensions));
        meanValue += val;
      }
      meanValue /= shape[axis];

      num sumation = 0;

      for (int i = 0; i < externlLoop; i++) {
        for (int y = 0; y < shape[axis]; y++) {
          int factor = i ~/ innerDimensions;
          int location = i % innerDimensions;
          int pointer = location + factor * jump;

          num val = rowOrderIndexing(pointer + (y * innerDimensions));
          sumation += math.pow(val - meanValue, 2);
        }
      }

      operatorHelper.addResult(math.sqrt(sumation / (shape[axis] - 1)));
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  BaseTensor<num> variance({int? axis, bool keepDims = false}) {
    if (axis == null) {
      num meanValue = 0;

      for (num element in tensor) {
        meanValue += element;
      }
      meanValue /= tensor.length;
      num sumation = 0;

      for (num element in tensor) {
        sumation += math.pow(element - meanValue, 2);
      }

      return ScalarTensor<num>(sumation / (tensor.length - 1));
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
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    int externlLoop = shape.shape.multiply(exclude: axis);
    int innerDimensions = shape.shape.multiply(start: axis + 1);
    int jump = shape.shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      num meanValue = 0;
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = rowOrderIndexing(pointer + (y * innerDimensions));
        meanValue += val;
      }
      meanValue /= shape[axis];

      num sumation = 0;

      for (int i = 0; i < externlLoop; i++) {
        for (int y = 0; y < shape[axis]; y++) {
          int factor = i ~/ innerDimensions;
          int location = i % innerDimensions;
          int pointer = location + factor * jump;

          num val = rowOrderIndexing(pointer + (y * innerDimensions));
          sumation += math.pow(val - meanValue, 2);
        }
      }

      operatorHelper.addResult(sumation / (shape[axis] - 1));
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> maximum(HomogeneousTensor<num> other) {
    final Shape? resultShape = Shape.tryBroadcast(shape, other.shape);
    if (resultShape == null) {
      throw BroadcastException(shape, other.shape);
    }

    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      num val1 = rowOrderIndexing(i % shape.length);
      num val2 = other.rowOrderIndexing(i % other.shape.length);
      if (val1 > val2) {
        operatorHelper.addResult(val1);
      } else {
        operatorHelper.addResult(val2);
      }

      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> minimum(HomogeneousTensor<num> other) {
    final Shape? resultShape = Shape.tryBroadcast(shape, other.shape);
    if (resultShape == null) {
      throw BroadcastException(shape, other.shape);
    }

    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      num val1 = rowOrderIndexing(i % shape.length);
      num val2 = other.rowOrderIndexing(i % other.shape.length);
      if (val1 < val2) {
        operatorHelper.addResult(val1);
      } else {
        operatorHelper.addResult(val2);
      }

      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> sort({int? axis, bool keepDims = false}) {
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    if (axis == null) {
      QuickSort<num> quickSort = QuickSort<num>(tensor)..sort();
      operatorHelper.addResultList(quickSort.data);
      return operatorHelper.resultHomogeneousTensor(shape);
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

    int externlLoop = shape.shape.multiply(exclude: axis);
    int innerDimensions = shape.shape.multiply(start: axis + 1);
    int jump = shape.shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      List<num> resultValue = [];

      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = rowOrderIndexing(pointer + (y * innerDimensions));
        resultValue.add(val);
      }
      QuickSort<num> quickSort = QuickSort<num>(resultValue)..sort();

      operatorHelper.addResultList(quickSort.data);
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<int> argSort({int? axis, bool keepDims = false}) {
    OperatorHelper<int> operatorHelper = OperatorHelper<int>();

    if (axis == null) {
      QuickSort<num> quickSort = QuickSort<num>(tensor)..sort();
      operatorHelper.addResultList(quickSort.indcies);
      return operatorHelper.resultHomogeneousTensor(shape);
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

    int externlLoop = shape.shape.multiply(exclude: axis);
    int innerDimensions = shape.shape.multiply(start: axis + 1);
    int jump = shape.shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      List<num> resultValue = [];

      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = rowOrderIndexing(pointer + (y * innerDimensions));
        resultValue.add(val);
      }
      QuickSort<num> quickSort = QuickSort<num>(resultValue)..sort();

      operatorHelper.addResultList(quickSort.indcies);
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }
}
