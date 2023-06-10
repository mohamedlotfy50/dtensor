class OperatorHelper<T> {
  Map<T, int> _histogram = {};
  List<T> _result = [];
  T? _sparseValue;
  int _maxCount = 0;

  bool get isSparse => _maxCount / _result.length >= 0.95;
  Map<int, T> get mapValue {
    Map<int, T> value = {};
    for (int i = 0; i < _result.length; i++) {
      if (_result[i] != _sparseValue) {
        value[i] = _result[i];
      }
    }
    return value;
  }

  List<T> get tensorValue => _result;
  T get sparseValue => _sparseValue!;

  void addResult(T value) {
    _result.add(value);
    _countValue(value);
  }

  void _countValue(T value) {
    if (_histogram[value] == null) {
      _histogram[value] = 0;
    }
    _histogram[value] = _histogram[value]! + 1;
    if (_sparseValue == null || _histogram[value]! > _maxCount) {
      _sparseValue = value;
      _maxCount = _histogram[value]!;
    }
  }
}

extension NumResult on OperatorHelper<num> {
  void min(int index, num value) {
    if ((index > value)) {
      throw Exception();
    } else if (index == _result.length) {
      _result.add(value);
      _countValue(value);
    } else if (_result[index] > value) {
      _result[index] = value;
      _countValue(value);
    }
  }

  void max(int index, num value) {
    if (index == _result.length) {
      _result.add(value);
    } else if (_result[index] < value) {
      _result[index] = value;
    }
    _countValue(value);
  }
}
