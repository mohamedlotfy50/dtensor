part of '../../tensor/src/dtensor.dart';

extension numDTensorExtension on DTensor<num> {
  DTensor<num> operator +(DTensor<num> other) {
    return DTensor<num>._(_tensor.add(other._tensor));
  }

  DTensor<num> operator -(DTensor<num> other) {
    return DTensor<num>._(_tensor.subtract(other._tensor));
  }

  DTensor<num> operator *(DTensor<num> other) {
    return DTensor<num>._(_tensor.multiply(other._tensor));
  }

  DTensor<num> operator /(DTensor<num> other) {
    return DTensor<num>._(_tensor.divid(other._tensor));
  }

  DTensor<num> dot(DTensor<num> other) {
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .dot(other._tensor as HomogeneousTensor<num>));
  }

  DTensor<num> matMult(DTensor<num> other) {
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .matMult(other._tensor as HomogeneousTensor<num>));
  }

  DTensor<num> exp() {
    return DTensor<num>._(_tensor.exp());
  }

  DTensor<num> pow(num exponent) {
    return DTensor<num>._(_tensor.pow(exponent));
  }

  DTensor<num> sqrt() {
    return DTensor._(_tensor.sqrt());
  }

  DTensor<num> sign() {
    return DTensor._(_tensor.sign());
  }

  DTensor<num> log() {
    return DTensor._(_tensor.log());
  }

  DTensor<num> max({int? axis, bool keepDims = false}) {
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .max(axis: axis, keepDims: keepDims));
  }

  DTensor<num> min({int? axis, bool keepDims = false}) {
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .min(axis: axis, keepDims: keepDims));
  }

  DTensor<num> sum({int? axis, bool keepDims = false}) {
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .sum(axis: axis, keepDims: keepDims));
  }

  DTensor<num> mean({int? axis, bool keepDims = false}) {
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .mean(axis: axis, keepDims: keepDims));
  }

  DTensor<num> mode({int? axis, bool keepDims = false}) {
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .mode(axis: axis, keepDims: keepDims));
  }

  DTensor<num> median({int? axis, bool keepDims = false}) {
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .median(axis: axis, keepDims: keepDims));
  }

  // List<List<num>> argSort() {
  //   if (axis == null) {
  //     return TensorHelper.transformFlatIndecesToShape(_tensor.argSort(), shape);
  //   }
  //   if (axis > shape.length) {
  //     throw Exception();
  //   }
  // }
}
