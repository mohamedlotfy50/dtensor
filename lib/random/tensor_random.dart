import 'dart:math';

import 'package:dtensor/dtensor.dart';

class TensorRandom<T extends Object> {
  final Random _random;
  final int? seed;

  TensorRandom._(this._random, this.seed);
  factory TensorRandom({int? seed}) {
    if (seed == null) {
      return TensorRandom<T>._(Random.secure(), seed);
    }
    return TensorRandom<T>._(Random(seed), seed);
  }

  DTensor<T> randomChoice(DTensor<T> input, int length, {bool replace = true}) {
    throw Exception();
  }
}
