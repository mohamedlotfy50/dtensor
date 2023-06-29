part of '../../model/src/homogeneous_tensor.dart';

extension NumHomogeneousTensor on HomogeneousTensor<num> {
  HomogeneousTensor<num> homogeneousAdd(HomogeneousTensor<num> other) {
    final Shape? resultShape = Shape.tryProdcast(shape, other.shape);
    if (resultShape == null) {
      throw Exception();
    }

    if (this is ScalarTensor<num> && other is ScalarTensor<num>) {
      return ScalarTensor<num>(tensor.first + other.tensor.first);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      num value = rowOrderIndexing(i % shape.length) +
          other.rowOrderIndexing(i % other.shape.length);

      operatorHelper.addResult(value);
      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> homogeneousSubtract(HomogeneousTensor<num> other) {
    final Shape? resultShape = Shape.tryProdcast(shape, other.shape);
    if (resultShape == null) {
      throw Exception();
    }

    if (this is ScalarTensor<num> && other is ScalarTensor<num>) {
      return ScalarTensor<num>(tensor.first - other.tensor.first);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      num value = rowOrderIndexing(i % shape.length) -
          other.rowOrderIndexing(i % other.shape.length);

      operatorHelper.addResult(value);
      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> homogeneousMultiply(HomogeneousTensor<num> other) {
    final Shape? resultShape = Shape.tryProdcast(shape, other.shape);
    if (resultShape == null) {
      throw Exception();
    }

    if (this is ScalarTensor<num> && other is ScalarTensor<num>) {
      return ScalarTensor<num>(tensor.first * other.tensor.first);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      num value = rowOrderIndexing(i % shape.length) *
          other.rowOrderIndexing(i % other.shape.length);

      operatorHelper.addResult(value);
      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> homogeneousDivid(HomogeneousTensor<num> other) {
    final Shape? resultShape = Shape.tryProdcast(shape, other.shape);
    if (resultShape == null) {
      throw Exception();
    }

    if (this is ScalarTensor<num> && other is ScalarTensor<num>) {
      return ScalarTensor<num>(tensor.first / other.tensor.first);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      num value = rowOrderIndexing(i % shape.length) /
          other.rowOrderIndexing(i % other.shape.length);

      operatorHelper.addResult(value);
      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<num> dot(HomogeneousTensor<num> other) {
    throw Exception();
  }

  HomogeneousTensor<num> matMult(HomogeneousTensor<num> other) {
    if (this is ScalarTensor<num> || other is ScalarTensor<num>) {
      throw Exception();
    }
    final Shape? resultShape = Shape.matMult(this.shape, other.shape);

    if (resultShape == null) {
      throw Exception();
    }
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

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
    } else if (axis >= 0 && axis < shape.length) {
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
    } else {
      throw Exception();
    }
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
    } else if (axis >= 0 && axis < shape.length) {
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
    } else {
      throw Exception();
    }
  }

  HomogeneousTensor<num> sum({int? axis, bool keepDims = false}) {
    if (axis == null) {
      num maxValue = 0;
      for (num element in tensor) {
        maxValue += element;
      }
      return ScalarTensor<num>(maxValue);
    } else if (axis >= 0 && axis < shape.length) {
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
    } else {
      throw Exception();
    }
  }

  HomogeneousTensor<num> mean({int? axis, bool keepDims = false}) {
    if (axis == null) {
      num maxValue = 0;
      for (num element in tensor) {
        maxValue += element;
      }
      return ScalarTensor<num>(maxValue / tensor.length);
    } else if (axis >= 0 && axis < shape.length) {
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
    } else {
      throw Exception();
    }
  }

  HomogeneousTensor<num> median({int? axis, bool keepDims = false}) {
    if (axis == null) {
      List<num> tensorCopy = List<num>.from(tensor);
      tensorCopy.sort();
      double center = shape.size / 2;
      num first = tensorCopy[center.floor()];
      num second = tensorCopy[center.ceil()];
      return ScalarTensor<num>((first + second) / 2);
    } else if (axis >= 0 && axis < shape.length) {
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
    } else {
      throw Exception();
    }
  }

  BaseTensor<num> std({int? axis, bool keepDims = false}) {
    //TODO: implement standerd diviasion
    throw Exception();
  }
}
