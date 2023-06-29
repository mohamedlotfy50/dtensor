part of './dtensor.dart';

class _DtensorIterator<T extends Object> extends Iterator<DTensor<T>> {
  final BaseTensor<T> _tensor;

  int _index = 0;

  _DtensorIterator(this._tensor);

  @override
  DTensor<T> get current {
    if (_tensor is ScalarTensor<T>) {
      throw Exception();
    } else if (_tensor.shape.length == 1) {
      return DTensor<T>._(ScalarTensor<T>(
        _tensor.rowOrderIndexing(_index),
      ));
    }
    return DTensor<T>._(
      _tensor.axisRowElements(_index, 0),
    );
  }

  @override
  bool moveNext() {
    _index++;

    return _index < _tensor.shape.first;
  }
}
