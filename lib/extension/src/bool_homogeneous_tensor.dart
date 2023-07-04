part of '../../model/src/homogeneous_tensor.dart';

extension BoolHomogeneousTensorExtension on HomogeneousTensor<bool> {
  HomogeneousTensor<bool> homogeneousAnd(HomogeneousTensor<bool> other) {
    if (tensor is ScalarTensor<bool> && other.tensor is ScalarTensor<bool>) {
      return ScalarTensor<bool>(tensor.first & other.tensor.first);
    }
    final Shape? resultShape = Shape.tryProdcast(shape, other.shape);
    if (resultShape == null) {
      throw Exception();
    }

    OperatorHelper<bool> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      bool value = rowOrderIndexing(i % shape.size) &
          other.rowOrderIndexing(i % other.shape.size);

      operatorHelper.addResult(value);
      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<bool> homogeneousOr(HomogeneousTensor<bool> other) {
    if (tensor is ScalarTensor<bool> && other.tensor is ScalarTensor<bool>) {
      return ScalarTensor<bool>(tensor.first | other.tensor.first);
    }
    final Shape? resultShape = Shape.tryProdcast(shape, other.shape);
    if (resultShape == null) {
      throw Exception();
    }

    OperatorHelper<bool> operatorHelper = OperatorHelper();
    int i = 0;
    while (i < shape.size || i < other.shape.size) {
      bool value = rowOrderIndexing(i % shape.size) |
          other.rowOrderIndexing(i % other.shape.size);

      operatorHelper.addResult(value);
      i += 1;
    }
    return operatorHelper.resultHomogeneousTensor(resultShape);
  }

  HomogeneousTensor<bool> homogeneousNot() {
    if (this is ScalarTensor<bool>) {
      return ScalarTensor<bool>(!(tensor.first));
    }
    OperatorHelper<bool> operatorHelper = OperatorHelper();
    for (bool element in tensor) {
      operatorHelper.addResult(!element);
    }
    return operatorHelper.resultHomogeneousTensor(shape);
  }
}
