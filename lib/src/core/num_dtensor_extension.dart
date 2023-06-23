part of './dtensor.dart';

extension numDTensorExtension on DTensor<num> {
  //!add
  DTensor<num> operator +(DTensor<num> other) {
    final Shape? resultShape =
        Shape.tryProdcast(_tensor.shape, other._tensor.shape);
    if (resultShape == null) {
      throw Exception();
    }

    if (_tensor is ScalarTensor<num> && other._tensor is ScalarTensor<num>) {
      return DTensor._(
          ScalarTensor<num>(_tensor.tensor.first + other._tensor.tensor.first));
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < _tensor.shape.size || i < other._tensor.shape.size) {
      num value = _tensor.getRowElementByOrder(i % _tensor.shape.size) +
          other._tensor.getRowElementByOrder(i % other._tensor.shape.size);

      operatorHelper.addResult(value);
      i += 1;
    }
    if (operatorHelper.isSparse) {
      return DTensor._(
        SparesTensor(operatorHelper.mapValue, resultShape,
            operatorHelper.sparseValue, MemoryOrder.c),
      );
    }

    return DTensor._(
      DenseTensor(operatorHelper.tensorValue, resultShape, MemoryOrder.c),
    );
  }

//!subtract
  DTensor<num> operator -(DTensor<num> other) {
    final Shape? resultShape =
        Shape.tryProdcast(_tensor.shape, other._tensor.shape);
    if (resultShape == null) {
      throw Exception();
    }

    if (_tensor is ScalarTensor<num> && other._tensor is ScalarTensor<num>) {
      return DTensor._(
          ScalarTensor<num>(_tensor.tensor.first - other._tensor.tensor.first));
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < _tensor.shape.size || i < other._tensor.shape.size) {
      num value = _tensor.getRowElementByOrder(i % _tensor.shape.size) -
          other._tensor.getRowElementByOrder(i % other._tensor.shape.size);

      operatorHelper.addResult(value);
      i += 1;
    }
    if (operatorHelper.isSparse) {
      return DTensor._(
        SparesTensor(operatorHelper.mapValue, resultShape,
            operatorHelper.sparseValue, MemoryOrder.c),
      );
    }

    return DTensor._(
      DenseTensor(operatorHelper.tensorValue, resultShape, MemoryOrder.c),
    );
  }

  //!multiply
  DTensor<num> operator *(DTensor<num> other) {
    final Shape? resultShape =
        Shape.tryProdcast(_tensor.shape, other._tensor.shape);
    if (resultShape == null) {
      throw Exception();
    }

    if (_tensor is ScalarTensor<num> && other._tensor is ScalarTensor<num>) {
      return DTensor._(
          ScalarTensor<num>(_tensor.tensor.first * other._tensor.tensor.first));
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < _tensor.shape.size || i < other._tensor.shape.size) {
      num value = _tensor.getRowElementByOrder(i % _tensor.shape.size) *
          other._tensor.getRowElementByOrder(i % other._tensor.shape.size);

      operatorHelper.addResult(value);
      i += 1;
    }
    if (operatorHelper.isSparse) {
      return DTensor._(
        SparesTensor(operatorHelper.mapValue, resultShape,
            operatorHelper.sparseValue, MemoryOrder.c),
      );
    }

    return DTensor._(
      DenseTensor(operatorHelper.tensorValue, resultShape, MemoryOrder.c),
    );
  }

//! divid
  DTensor<num> operator /(DTensor<num> other) {
    final Shape? resultShape =
        Shape.tryProdcast(_tensor.shape, other._tensor.shape);
    if (resultShape == null) {
      throw Exception();
    }

    if (_tensor is ScalarTensor<num> && other._tensor is ScalarTensor<num>) {
      return DTensor._(
          ScalarTensor<num>(_tensor.tensor.first / other._tensor.tensor.first));
    }
    OperatorHelper<num> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < _tensor.shape.size || i < other._tensor.shape.size) {
      num value = _tensor.getRowElementByOrder(i % _tensor.shape.size) /
          other._tensor.getRowElementByOrder(i % other._tensor.shape.size);

      operatorHelper.addResult(value);
      i += 1;
    }
    if (operatorHelper.isSparse) {
      return DTensor._(
        SparesTensor(operatorHelper.mapValue, resultShape,
            operatorHelper.sparseValue, MemoryOrder.c),
      );
    }

    return DTensor._(
      DenseTensor(operatorHelper.tensorValue, resultShape, MemoryOrder.c),
    );
  }

  //! dot product
  DTensor<num> dot(DTensor<num> second) {
    if (this is ScalarTensor<num> || second is ScalarTensor<num>) {
      return this * second;
    }

    throw Exception();
  }

  //! matrix multiply
  DTensor<num> matMult(DTensor<num> second) {
    if (this is ScalarTensor<num> || second is ScalarTensor<num>) {
      throw Exception();
    }
    final Shape? resultShape =
        Shape.matMult(this._tensor.shape, second._tensor.shape);

    if (resultShape == null) {
      throw Exception();
    }
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();
    num resut = 0;
    for (int i = 0; i < _tensor.shape.last; i++) {
      resut += _tensor.getRowElementByOrder(i) *
          second._tensor.getColumnElementByOrder(i);
    }
    if (operatorHelper.isSparse) {
      return DTensor._(
        SparesTensor(
          operatorHelper.mapValue,
          resultShape,
          operatorHelper.sparseValue,
          this._tensor.memoryOrder,
        ),
      );
    }

    return DTensor._(
      DenseTensor(
        operatorHelper.tensorValue,
        resultShape,
        this._tensor.memoryOrder,
      ),
    );
  }

  //? end

  DTensor<num> max({int? axis, bool keepDims = false}) {
    if (axis == null) {
      return DTensor<num>._(
        _tensor.max(),
      );
    }
    if (axis > shape.length) {
      throw Exception();
    }
    late final Shape resultShape;
    if (keepDims) {
      resultShape = _tensor.shape.replaceDim(axis, 1);
    } else {
      resultShape = _tensor.shape.removeDim(axis);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    int externlLoop = shape.multiply(exclude: axis);
    int innerDimensions = shape.multiply(start: axis + 1);
    int jump = shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      num? small;
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = _tensor.getRowElementByOrder(pointer + (y * innerDimensions));
        if (small == null || val > small) {
          small = val;
        }
      }
      operatorHelper.addResult(small!);
    }
    if (operatorHelper.isSparse) {
      return DTensor._(
        SparesTensor(
          operatorHelper.mapValue,
          resultShape,
          operatorHelper.sparseValue,
          MemoryOrder.c,
        ),
      );
    }

    return DTensor._(
      DenseTensor(
        operatorHelper.tensorValue,
        resultShape,
        MemoryOrder.c,
      ),
    );
  }

  DTensor<num> min({int? axis, bool keepDims = false}) {
    if (axis == null) {
      return DTensor<num>._(
        _tensor.min(),
      );
    }
    if (axis > shape.length) {
      throw Exception();
    }
    late final Shape resultShape;
    if (keepDims) {
      resultShape = _tensor.shape.replaceDim(axis, 1);
    } else {
      resultShape = _tensor.shape.removeDim(axis);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    int externlLoop = shape.multiply(exclude: axis);
    int innerDimensions = shape.multiply(start: axis + 1);
    int jump = shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      num? small;
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = _tensor.getRowElementByOrder(pointer + (y * innerDimensions));
        if (small == null || val < small) {
          small = val;
        }
      }
      operatorHelper.addResult(small!);
    }
    if (operatorHelper.isSparse) {
      return DTensor._(
        SparesTensor(
          operatorHelper.mapValue,
          resultShape,
          operatorHelper.sparseValue,
          MemoryOrder.c,
        ),
      );
    }

    return DTensor._(
      DenseTensor(
        operatorHelper.tensorValue,
        resultShape,
        MemoryOrder.c,
      ),
    );
  }

  DTensor<num> sum({int? axis, bool keepDims = false}) {
    if (axis == null) {
      return DTensor<num>._(
        _tensor.max(),
      );
    }
    if (axis > shape.length) {
      throw Exception();
    }
    late final Shape resultShape;
    if (keepDims) {
      resultShape = _tensor.shape.replaceDim(axis, 1);
    } else {
      resultShape = _tensor.shape.removeDim(axis);
    }
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    int externlLoop = shape.multiply(exclude: axis);
    int innerDimensions = shape.multiply(start: axis + 1);
    int jump = shape.multiply(start: axis);

    for (int i = 0; i < externlLoop; i++) {
      num result = 0;
      for (int y = 0; y < shape[axis]; y++) {
        int factor = i ~/ innerDimensions;
        int location = i % innerDimensions;
        int pointer = location + factor * jump;

        num val = _tensor.getRowElementByOrder(pointer + (y * innerDimensions));
        result += val;
      }
      operatorHelper.addResult(result);
    }
    if (operatorHelper.isSparse) {
      return DTensor._(
        SparesTensor(
          operatorHelper.mapValue,
          resultShape,
          operatorHelper.sparseValue,
          MemoryOrder.c,
        ),
      );
    }

    return DTensor._(
      DenseTensor(
        operatorHelper.tensorValue,
        resultShape,
        MemoryOrder.c,
      ),
    );
  }
}
