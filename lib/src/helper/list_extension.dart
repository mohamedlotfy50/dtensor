extension ListExtension on List<int> {
  int multiply({int? start, int? end}) {
    int total = 1;
    for (int i = (start ?? 0); i < (end ?? length); i++) {
      total *= this[i];
    }
    return total;
  }

  int sum() {
    int total = 1;
    for (int dim in this) {
      total += dim;
    }
    return total;
  }

  bool isSymmetric() {
    for (int i = 0; i < this.length - 1; i++) {
      if (this[i] != this[i + 1]) {
        return false;
      }
    }
    return true;
  }

  int max() {
    int maxValue = 0;
    for (int dim in this) {
      if (dim > maxValue) {
        maxValue = dim;
      }
    }
    return maxValue;
  }
}
