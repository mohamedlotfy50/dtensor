import 'package:dtensor/util/src/list_extension.dart';

class Shape {
  final List<int> shape;
  final int size;
  final List<List<int>> dimCount;
  int get length => shape.length;
  int get first => shape.first;
  int get last => shape.last;
  bool get isEmpty => shape.length == 1 && shape.first == 0;
  bool get isNotEmpty => !isEmpty;
  bool get isScalar => shape.isEmpty && dimCount.isEmpty;
  bool get isRagged => shape.isNotEmpty && dimCount.isNotEmpty;

  Shape({
    required this.shape,
    required this.size,
    this.dimCount = const [],
  });

  static bool isEqual(Shape first, Shape second) {
    if (first.length != second.length) {
      return false;
    }
    for (int i = 0; i < first.length; i++) {
      if (first[i] != second[i]) {
        return false;
      }
    }
    return true;
  }

  static Shape? tryProdcast(Shape firstShape, Shape secondShape) {
    final Shape minShape;
    final Shape maxShape;

    if ((secondShape.length <= firstShape.length) &&
        (secondShape.size <= firstShape.size)) {
      minShape = secondShape;
      maxShape = firstShape;
    } else {
      minShape = firstShape;
      maxShape = secondShape;
    }

    for (int i = minShape.length - 1; i >= 0; i--) {
      final bool isNotEqual = secondShape[i] != firstShape[i];
      final bool shapeIsNotOne = firstShape[i] != 1;
      final bool otherShapeIsNotOne = secondShape[i] != 1;
      if (isNotEqual && shapeIsNotOne && otherShapeIsNotOne) {
        return null;
      }
    }
    return maxShape;
  }

  Shape transpose() {
    //TODO:fix transpose for ragged

    List<int> reversedShape = List<int>.from(shape);
    if (isEmpty) {
      return Shape(dimCount: dimCount, shape: reversedShape, size: size);
    }

    reversedShape = reversedShape.reversed.toList();
    List<List<int>> reversedDim = List<List<int>>.from(dimCount);

    if (dimCount.isNotEmpty) {
      List<List<int>> result = [];

      for (List<int> l in reversedDim) {
        result.add(l.reversed.toList());
      }
      reversedDim = result;
    }

    return Shape(dimCount: reversedDim, shape: reversedShape, size: size);
  }

  int operator [](int index) {
    try {
      return shape[index];
    } catch (e) {
      throw Exception();
    }
  }

  static Shape? dot(Shape first, Shape second) {
    if ((first.length == 1 && second.length == 1) ||
        (first.length == 0 && second.length == 0)) {
      return Shape(
        shape: [],
        size: 1,
        dimCount: [],
      );
    } else if (second.length == 1 && first.last == second.first) {
      List<int> firstShape = List<int>.from(first.shape);
      List<int> secondShape = List<int>.from(second.shape);
      firstShape.removeLast();
      secondShape.removeAt(second.shape.length - 2);
      List<int> resultShape = [...firstShape, ...secondShape];

      return Shape(
        shape: resultShape,
        size: resultShape.multiply(),
        dimCount: [],
      );
    } else if (second.length >= 2 && first.last == second[second.length - 2]) {
      List<int> firstShape = List<int>.from(first.shape);
      List<int> secondShape = List<int>.from(second.shape);
      firstShape.removeLast();
      secondShape.removeAt(second.shape.length - 2);
      List<int> resultShape = [...firstShape, ...secondShape];

      return Shape(
        shape: resultShape,
        size: resultShape.multiply(),
        dimCount: [],
      );
    }
    return null;
  }

  static Shape? matMult(Shape first, Shape second) {
    if (first.length == 1 &&
        second.length == 1 &&
        first.first == second.first) {
      return Shape(
        shape: [],
        size: 1,
        dimCount: [],
      );
    } else if (second.length == 1 && first.last == second.first) {
      List<int> firstShape = List<int>.from(first.shape);
      List<int> secondShape = List<int>.from(second.shape);
      firstShape.removeLast();
      secondShape.removeAt(0);
      List<int> resultShape = [...firstShape, ...secondShape];

      return Shape(
        shape: resultShape,
        size: resultShape.multiply(),
        dimCount: [],
      );
    } else if (second.length >= 2 && first.last == second[second.length - 2]) {
      List<int> firstShape = List<int>.from(first.shape);
      firstShape.removeLast();
      List<int> resultShape = [...firstShape, second.last];

      return Shape(
        shape: resultShape,
        size: resultShape.multiply(),
        dimCount: [],
      );
    }
    return null;
  }

  Shape removeDim(int index) {
    if (index > length - 1) {
      throw Exception();
    }
    List<int> newShape = List.from(shape);
    int removedDim = newShape.removeAt(index);
    return Shape(
      shape: newShape,
      size: size ~/ removedDim,
      dimCount: dimCount,
    );
  }

  Shape replaceDim(int index, int value) {
    if (index > length - 1) {
      throw Exception();
    }
    List<int> newShape = List.from(shape);
    int removedDim = newShape[index];
    newShape[index] = value;

    return Shape(
      shape: newShape,
      size: size ~/ removedDim * value,
      dimCount: dimCount,
    );
  }

  Shape swap(int a, int b) {
    if (a > length || b > length) {
      throw Exception();
    }
    List<int> newShape = List.from(shape);
    final first = newShape[a];

    final second = newShape[b];
    newShape[a] = second;
    newShape[b] = first;

    return Shape(shape: newShape, size: size, dimCount: dimCount);
  }
}
