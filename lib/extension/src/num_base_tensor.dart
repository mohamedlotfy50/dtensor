part of '../../model/src/base_tensor.dart';

extension NumBaseTensorExtension on BaseTensor<num> {
  ScalarTensor<num> max({int? axis, bool keepDims = false}) {
    if (this is HomogeneousTensor<num>) {
      return this.max(axis: axis, keepDims: keepDims);
    }
    throw Exception();
  }

  ScalarTensor<num> sum({int? axis, bool keepDims = false}) {
    if (this is HomogeneousTensor<num>) {
      return this.sum(axis: axis, keepDims: keepDims);
    }
    throw Exception();
  }

  ScalarTensor<num> mean({int? axis, bool keepDims = false}) {
    if (this is HomogeneousTensor<num>) {
      return this.mean(axis: axis, keepDims: keepDims);
    }
    throw Exception();
  }

  ScalarTensor<num> median({int? axis, bool keepDims = false}) {
    if (this is HomogeneousTensor<num>) {
      return this.median(axis: axis, keepDims: keepDims);
    }
    throw Exception();
  }

  ScalarTensor<num> min({int? axis, bool keepDims = false}) {
    if (this is HomogeneousTensor<num>) {
      return this.min(axis: axis, keepDims: keepDims);
    }
    throw Exception();
  }

  BaseTensor<num> std({int? axis, bool keepDims = false}) {
    if (this is HomogeneousTensor<num>) {
      return this.std(axis: axis, keepDims: keepDims);
    }
    throw Exception();
  }

  BaseTensor<num> pow(num exponent) {
    List<num> result = [];
    for (num x in tensor) {
      result.add(math.pow(x, exponent));
    }
    if (this is RaggedTensor<num>) {
      return RaggedTensor(result, shape, memoryOrder);
    } else if (shape.isScalar) {
      return ScalarTensor<num>(result.first);
    }
    return DenseTensor<num>(result, shape, memoryOrder);
  }

  BaseTensor<num> exp() {
    List<num> result = [];
    for (num x in tensor) {
      result.add(math.exp(x));
    }
    if (shape.isScalar) {
      return ScalarTensor<num>(result.first);
    }
    return DenseTensor<num>(result, shape, memoryOrder);
  }

  BaseTensor<num> log() {
    List<num> result = [];
    for (num element in tensor) {
      result.add(math.log(element));
    }
    if (shape.isScalar) {
      return ScalarTensor<num>(result.first);
    }
    return DenseTensor<num>(result, shape, memoryOrder);
  }

  BaseTensor<num> sign() {
    List<num> result = [];
    for (num element in tensor) {
      result.add(element.sign);
    }
    if (shape.isScalar) {
      return ScalarTensor<num>(result.first);
    }
    return DenseTensor<num>(result, shape, memoryOrder);
  }

  BaseTensor<num> sqrt() {
    List<num> result = [];
    for (num element in tensor) {
      result.add(math.sqrt(element));
    }
    if (shape.isScalar) {
      return ScalarTensor<num>(result.first);
    }
    return DenseTensor<num>(result, shape, memoryOrder);
  }

  BaseTensor<num> add(BaseTensor<num> other) {
    if (this is HomogeneousTensor<num> && other is HomogeneousTensor<num>) {
      return this.add(other);
    }
    throw Exception();
  }

  BaseTensor<num> subtract(BaseTensor<num> other) {
    if (this is HomogeneousTensor<num> && other is HomogeneousTensor<num>) {
      return this.subtract(other);
    }
    throw Exception();
  }

  BaseTensor<num> divid(BaseTensor<num> other) {
    if (this is HomogeneousTensor<num> && other is HomogeneousTensor<num>) {
      return this.divid(other);
    }
    throw Exception();
  }

  BaseTensor<num> multiply(BaseTensor<num> other) {
    if (this is HomogeneousTensor<num> && other is HomogeneousTensor<num>) {
      return this.multiply(other);
    }
    throw Exception();
  }
}
