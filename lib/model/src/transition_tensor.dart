import 'dart:typed_data';
import 'package:dtensor/util/src/list_extension.dart';

import '../../const/tensor_order.dart';
import '../../tensor/tensor.dart';
import './shape.dart';

import 'base_tensor.dart';

class TransitionTensor<T extends Object> {
  final Endian byteOrder;
  final int itemSize;
  final Type dataType;
  final TensorOrder memoryOrder;
  final Shape shape;
  final List<T> data;

  const TransitionTensor({
    required this.byteOrder,
    required this.itemSize,
    required this.dataType,
    required this.memoryOrder,
    required this.shape,
    required this.data,
  });

  factory TransitionTensor.fromMap(Map<String, dynamic> map) {
    return TransitionTensor<T>(
      byteOrder: map['byteOrder'],
      itemSize: map['itemSize'],
      memoryOrder: map['isFortran'] ? TensorOrder.f : TensorOrder.c,
      shape: Shape(
        dimCount: [],
        shape: map['shape'],
        size: (map['shape'] as List<int>).sum(),
      ),
      data: map['data'],
      dataType: T,
    );
  }

  factory TransitionTensor.fromTensor(BaseTensor<T> tensor) {
    return TransitionTensor<T>(
      byteOrder: Endian.big,
      itemSize: tensor.tensor.length,
      dataType: T,
      memoryOrder: tensor.memoryOrder.order,
      shape: tensor.shape,
      data: tensor.tensor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'byteOrder': byteOrder,
      'itemSize': itemSize,
      'dataType': dataType,
      'shape': shape.shape,
      'dimCount': shape.dimCount,
      'memoryOrder': memoryOrder,
      'data': data,
    };
  }

  BaseTensor<T> toTensor() {
    if (shape.isScalar && data.length == 1) {
      return ScalarTensor<T>(data.first);
    } else if (shape.isRagged) {
      return RaggedTensor<T>(data, shape, memoryOrder);
    }
    final SparesTensor<T>? sparesTensor = _calculateSparsity();
    if (sparesTensor != null) {
      return sparesTensor;
    }

    return DenseTensor<T>(data, shape, memoryOrder);
  }

  SparesTensor<T>? _calculateSparsity() {
    T? sparse;
    int maxCount = 0;
    Map<T, int> histogram = {};

    for (T element in data) {
      if (histogram[element] == null) {
        histogram[element] = 0;
      }
      histogram[element] = histogram[element]! + 1;
      if (sparse == null || histogram[element]! > maxCount) {
        sparse = element;
        maxCount = histogram[element]!;
      }
    }

    if (maxCount / data.length >= 0.95) {
      Map<int, T> value = {};
      for (int i = 0; i < data.length; i++) {
        if (data[i] != sparse) {
          value[i] = data[i];
        }
      }

      return SparesTensor<T>(value, shape, sparse!, memoryOrder);
    }

    return null;
  }
}
