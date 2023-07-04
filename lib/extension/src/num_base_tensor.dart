part of '../../model/src/base_tensor.dart';

extension NumBaseTensorExtension on BaseTensor<num> {
  BaseTensor<num> pow(num exponent) {
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();
    for (num x in tensor) {
      operatorHelper.addResult(math.pow(x, exponent));
    }
    if (this is HomogeneousTensor<num>) {
      return operatorHelper.resultHomogeneousTensor(shape,
          memoryOrder: memoryOrder.order);
    }
    return operatorHelper.resultRaggedTensor(shape,
        memoryOrder: memoryOrder.order);
  }

  BaseTensor<num> exp() {
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();
    for (num x in tensor) {
      operatorHelper.addResult(math.exp(x));
    }
    if (this is HomogeneousTensor<num>) {
      return operatorHelper.resultHomogeneousTensor(shape,
          memoryOrder: memoryOrder.order);
    }
    return operatorHelper.resultRaggedTensor(shape,
        memoryOrder: memoryOrder.order);
  }

  BaseTensor<num> log() {
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();
    for (num element in tensor) {
      operatorHelper.addResult(math.log(element));
    }
    if (this is HomogeneousTensor<num>) {
      return operatorHelper.resultHomogeneousTensor(shape,
          memoryOrder: memoryOrder.order);
    }
    return operatorHelper.resultRaggedTensor(shape,
        memoryOrder: memoryOrder.order);
  }

  BaseTensor<num> sign() {
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();
    for (num element in tensor) {
      operatorHelper.addResult(element.sign);
    }
    if (this is HomogeneousTensor<num>) {
      return operatorHelper.resultHomogeneousTensor(shape,
          memoryOrder: memoryOrder.order);
    }
    return operatorHelper.resultRaggedTensor(shape,
        memoryOrder: memoryOrder.order);
  }

  BaseTensor<num> sqrt() {
    OperatorHelper<num> operatorHelper = OperatorHelper<num>();
    for (num element in tensor) {
      operatorHelper.addResult(math.sqrt(element));
    }
    if (this is HomogeneousTensor<num>) {
      return operatorHelper.resultHomogeneousTensor(shape,
          memoryOrder: memoryOrder.order);
    }
    return operatorHelper.resultRaggedTensor(shape,
        memoryOrder: memoryOrder.order);
  }

  BaseTensor<num> add(BaseTensor<num> other) {
    if (this is HomogeneousTensor<num> && other is HomogeneousTensor<num>) {
      return (this as HomogeneousTensor<num>).homogeneousAdd(other);
    }
    throw Exception();
  }

  BaseTensor<num> subtract(BaseTensor<num> other) {
    if (this is HomogeneousTensor<num> && other is HomogeneousTensor<num>) {
      return (this as HomogeneousTensor<num>).homogeneousSubtract(other);
    }
    throw Exception();
  }

  BaseTensor<num> divid(BaseTensor<num> other) {
    if (this is HomogeneousTensor<num> && other is HomogeneousTensor<num>) {
      return (this as HomogeneousTensor<num>).homogeneousDivid(other);
    }
    throw Exception();
  }

  BaseTensor<num> multiply(BaseTensor<num> other) {
    if (this is HomogeneousTensor<num> && other is HomogeneousTensor<num>) {
      return (this as HomogeneousTensor<num>).homogeneousMultiply(other);
    }
    throw Exception();
  }
}
