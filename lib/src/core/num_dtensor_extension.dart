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
    //  else if (this.shape.length == 2 && second.shape.length == 2) {
    //   return matMult(second);
    // }
    // final Shape? resultShape =
    //     Shape.dot(this._tensor.shape, second._tensor.shape);
    // if (resultShape == null) {
    //   throw Exception();
    // }
    // OperatorHelper<num> operatorHelper = OperatorHelper<num>();

    late int i;
    if (this.shape.length == 1 && second.shape.length == 1) {
      i = 1;
    } else {
      i = this.shape.last;
    }
    for (int i = 0; i < this._tensor.shape.size; i++) {
      print(
          '${this._tensor.getRowElementByOrder(i)}x${second._tensor.getColumnElementByOrder(i)}');
    }
    // while (i > 0) {
    //   int dim = 0;
    //   num sum = 0;

    //   while (dim < this._tensor.shape.last || dim < second._tensor.shape.last) {
    //     // num result = this._tensor.getRowElementByRowAndColumn(i, dim) *
    //     //     second._tensor.getColumnElementByRowAndColumn(dim, i);
    //     // sum += result;
    //     dim += 1;
    //   }
    //   operatorHelper.addResult(sum);
    //   i -= 1;
    // }
    throw Exception();

    // if (operatorHelper.isSparse) {
    //   return DTensor._(
    //     SparesTensor(
    //       operatorHelper.mapValue,
    //       resultShape,
    //       operatorHelper.sparseValue,
    //       this._tensor.memoryOrder,
    //     ),
    //   );
    // }

    // return DTensor._(
    //   DenseTensor(
    //     operatorHelper.tensorValue,
    //     resultShape,
    //     this._tensor.memoryOrder,
    //   ),
    // );
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
    late final Shape newShape;
    if (keepDims) {
      newShape = _tensor.shape.replaceDim(axis, 1);
    } else {
      newShape = _tensor.shape.removeDim(axis);
    }
    List<num> result = List.filled(newShape.size, double.negativeInfinity);
    for (int i = 0; i < newShape.size; i++) {
      if (_tensor.getRowElementByOrder(i * newShape.size) > result[i]) {
        result[i] = _tensor.getRowElementByOrder(i);
      }
    }
    return DTensor._(
      DenseTensor(result, newShape, MemoryOrder.c),
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

    int step = shape.multiply(end: axis + 1);

    for (int i = 0; i < _tensor.shape.size; i++) {
      // print(_tensor.getRowElementByOrder(i));
      operatorHelper.min(i % step, _tensor.getRowElementByOrder(i));
    }
    print(operatorHelper.tensorValue.length);

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
