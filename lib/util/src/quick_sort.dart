class QuickSort<T extends num> {
  final List<int> indcies;
  final List<T> data;

  QuickSort._(this.indcies, this.data);

  factory QuickSort(List<T> dataList) {
    return QuickSort<T>._(List<int>.generate(dataList.length, (index) => index),
        List<T>.from(dataList));
  }

  void sort() {
    quickSort(0, data.length - 1);
  }

  void quickSort(int low, int high) {
    if (low < high) {
      int pi = partition(low, high);
      quickSort(low, pi - 1);
      quickSort(pi + 1, high);
    }
  }

  void swap(int i, int j) {
    T tempData = data[i];
    int tempIndex = indcies[i];
    data[i] = data[j];
    data[j] = tempData;

    indcies[i] = indcies[j];
    indcies[j] = tempIndex;
  }

  int partition(int low, int high) {
    T pivot = data[high];
    int i = low - 1;

    for (int j = low; j <= high; j++) {
      if (data[j] < pivot) {
        i++;
        swap(i, j);
      }
    }
    swap(i + 1, high);
    return i + 1;
  }
}
