part of '../../model/src/base_tensor.dart';

extension BoolBaseTensorExtension on BaseTensor<bool> {
  BaseTensor<bool> and(BaseTensor<bool> other) {
    if (this is HomogeneousTensor<bool> && other is HomogeneousTensor<bool>) {
      return (this as HomogeneousTensor<bool>).homogeneousAnd(other);
    }
    return this;
  }

  BaseTensor<bool> or(BaseTensor<bool> other) {
    if (this is HomogeneousTensor<bool> && other is HomogeneousTensor<bool>) {
      return (this as HomogeneousTensor<bool>).homogeneousOr(other);
    }
    return this;
  }

  BaseTensor<bool> not() {
    if (this is HomogeneousTensor<bool>) {
      return (this as HomogeneousTensor<bool>).homogeneousNot();
    }
    return this;
  }
}
