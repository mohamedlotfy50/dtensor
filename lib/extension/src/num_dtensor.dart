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
    if (_tensor is! HomogeneousTensor<num> ||
        other._tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .dot(other._tensor as HomogeneousTensor<num>));
  }

  DTensor<num> matMult(DTensor<num> other) {
    if (_tensor is! HomogeneousTensor<num> ||
        other._tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .matMult(other._tensor as HomogeneousTensor<num>));
  }

  DTensor<num> exp() {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._(_tensor.exp());
  }

  DTensor<num> sort({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .sort(axis: axis, keepDims: keepDims));
  }

  DTensor<int> argSort({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<int>._((_tensor as HomogeneousTensor<int>)
        .argSort(axis: axis, keepDims: keepDims));
  }

  DTensor<num> pow(num exponent) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._(_tensor.pow(exponent));
  }

  DTensor<num> sqrt() {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor._(_tensor.sqrt());
  }

  DTensor<num> sign() {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor._(_tensor.sign());
  }

  DTensor<num> log() {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor._(_tensor.log());
  }

  DTensor<num> max({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .max(axis: axis, keepDims: keepDims));
  }

  DTensor<num> argMax({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .argMax(axis: axis, keepDims: keepDims));
  }

  DTensor<num> min({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .min(axis: axis, keepDims: keepDims));
  }

  DTensor<num> argMin({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .argMin(axis: axis, keepDims: keepDims));
  }

  DTensor<num> sum({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .sum(axis: axis, keepDims: keepDims));
  }

  DTensor<num> mean({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .mean(axis: axis, keepDims: keepDims));
  }

  DTensor<num> std({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .std(axis: axis, keepDims: keepDims));
  }

  DTensor<num> variance({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .variance(axis: axis, keepDims: keepDims));
  }

  DTensor<num> mode({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .mode(axis: axis, keepDims: keepDims));
  }

  DTensor<num> median({int? axis, bool keepDims = false}) {
    if (_tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .median(axis: axis, keepDims: keepDims));
  }

  DTensor<num> maximum(DTensor<num> other) {
    if (_tensor is! HomogeneousTensor<num> ||
        other._tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }

    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .maximum(other._tensor as HomogeneousTensor<num>));
  }

  DTensor<num> minimum(DTensor<num> other) {
    if (_tensor is! HomogeneousTensor<num> ||
        other._tensor is! HomogeneousTensor<num>) {
      throw Exception();
    }
    return DTensor<num>._((_tensor as HomogeneousTensor<num>)
        .minimum(other._tensor as HomogeneousTensor<num>));
  }
}
