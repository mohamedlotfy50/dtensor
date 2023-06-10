part of './dtensor.dart';

extension BoolDTensorExtension on DTensor<bool> {
  DTensor<bool> operator |(DTensor<bool> other) {
    final Shape? resultShape =
        Shape.tryProdcast(_tensor.shape, other._tensor.shape);
    if (resultShape == null) {
      throw Exception();
    }

    if (_tensor is ScalarTensor<bool> && other._tensor is ScalarTensor<bool>) {
      return DTensor._(ScalarTensor<bool>(
          _tensor.tensor.first | other._tensor.tensor.first));
    }
    OperatorHelper<bool> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < _tensor.shape.size || i < other._tensor.shape.size) {
      bool value = _tensor.getRowElementByOrder(i % _tensor.shape.size) |
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

  DTensor<bool> operator &(DTensor<bool> other) {
    final Shape? resultShape =
        Shape.tryProdcast(_tensor.shape, other._tensor.shape);
    if (resultShape == null) {
      throw Exception();
    }

    if (_tensor is ScalarTensor<bool> && other._tensor is ScalarTensor<bool>) {
      return DTensor._(ScalarTensor<bool>(
          _tensor.tensor.first & other._tensor.tensor.first));
    }
    OperatorHelper<bool> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < _tensor.shape.size || i < other._tensor.shape.size) {
      bool value = _tensor.getRowElementByOrder(i % _tensor.shape.size) &
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

  DTensor<bool> operator +(DTensor<bool> other) {
    return this | other;
  }

  DTensor<bool> operator *(DTensor<bool> other) {
    return this & other;
  }

  DTensor<bool> operator ~() {
    if (this is ScalarTensor<bool>) {
      return DTensor<bool>._(ScalarTensor<bool>(!(_tensor.tensor.first)));
    }
    OperatorHelper<bool> operatorHelper = OperatorHelper();
    for (bool element in _tensor.tensor) {
      operatorHelper.addResult(!element);
    }
    if (operatorHelper.isSparse) {
      return DTensor._(
        SparesTensor(
          operatorHelper.mapValue,
          _tensor.shape,
          operatorHelper.sparseValue,
          _tensor.memoryOrder,
        ),
      );
    }

    return DTensor._(
      DenseTensor(
        operatorHelper.tensorValue,
        _tensor.shape,
        _tensor.memoryOrder,
      ),
    );
  }

  DTensor<bool> max({int? axis, bool keepDims = false}) {
    if (axis == null) {
      return DTensor<bool>._(
        DenseTensor(
          [_tensor.contains(true)],
          Shape(shape: [1], size: 1, dimCount: []),
          _tensor.memoryOrder,
        ),
      );
    }
    if (axis > shape.length) {
      throw Exception();
    }
    throw Exception();
  }

  DTensor<bool> min({int? axis, bool keepDims = false}) {
    if (axis == null) {
      return DTensor<bool>._(
        DenseTensor(
          [_tensor.contains(true)],
          Shape(shape: [1], size: 1, dimCount: []),
          _tensor.memoryOrder,
        ),
      );
    }
    if (axis > shape.length) {
      throw Exception();
    }

    throw Exception();
  }
}
