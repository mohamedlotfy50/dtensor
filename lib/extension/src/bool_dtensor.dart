part of '../../tensor/src/dtensor.dart';

extension BoolDTensorExtension on DTensor<bool> {
  DTensor<bool> operator |(DTensor<bool> other) {
    return DTensor._(_tensor.or(other._tensor));
  }

  DTensor<bool> operator &(DTensor<bool> other) {
    return DTensor._(_tensor.and(other._tensor));
  }

  DTensor<bool> operator +(DTensor<bool> other) {
    return DTensor._(_tensor.or(other._tensor));
  }

  DTensor<bool> operator *(DTensor<bool> other) {
    return DTensor._(_tensor.and(other._tensor));
  }

  DTensor<bool> operator ~() {
    return DTensor._(_tensor.not());
  }
}
