part of '../../tensor/src/dtensor.dart';

extension numDTensorExtension on DTensor<num> {
  //!add
  DTensor<num> operator +(DTensor<num> other) {
    return DTensor<num>._(_tensor.add(other._tensor));
  }

//!subtract
  DTensor<num> operator -(DTensor<num> other) {
    return DTensor<num>._(_tensor.subtract(other._tensor));
  }

  //!multiply
  DTensor<num> operator *(DTensor<num> other) {
    return DTensor<num>._(_tensor.multiply(other._tensor));
  }

//! divid
  DTensor<num> operator /(DTensor<num> other) {
    return DTensor<num>._(_tensor.divid(other._tensor));
  }

  //! dot product
  DTensor<num> dot(DTensor<num> other) {
    throw Exception();
  }

  //! matrix multiply
  DTensor<num> matMult(DTensor<num> other) {
    throw Exception();
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

  //? end

  DTensor<num> max({int? axis, bool keepDims = false}) {
    throw Exception();
  }

  DTensor<num> min({int? axis, bool keepDims = false}) {
    throw Exception();
  }

  DTensor<num> sum({int? axis, bool keepDims = false}) {
    throw Exception();
  }

  DTensor<num> mean({int? axis, bool keepDims = false}) {
    throw Exception();
  }

  DTensor<num> mode({int? axis, bool keepDims = false}) {
    throw Exception();
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
