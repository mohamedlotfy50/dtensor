import '../../const/tensor_order.dart';
import '../../model/model.dart';
import '../../tensor/tensor.dart';
import 'tensor_extractor_helper.dart';

class TensorHelper {
  TensorHelper._();

  static BaseTensor<T> autoDetectType<T extends Object>({
    required dynamic value,
    required TensorOrder tensorOrder,
  }) {
    if (value is! List) {
      return ScalarTensor<T>(value);
    }
    final TensorExtractorHelper<T> tensorExtractorHelper =
        TensorExtractorHelper<T>();

    if (tensorOrder == TensorOrder.f &&
        value.isNotEmpty &&
        value.first is List) {
      _columnMajorOrder<T>(value, tensorExtractorHelper);
    } else {
      _rowMajorOrder<T>(value, tensorExtractorHelper);
    }
    if (tensorExtractorHelper.isRagged) {
      return RaggedTensor(
        tensorExtractorHelper.flatTensor,
        Shape(
            shape: tensorExtractorHelper.shape,
            size: tensorExtractorHelper.size,
            dimCount: tensorExtractorHelper.dimCount),
        tensorOrder,
      );
    } else if (tensorExtractorHelper.isSparse) {
      return SparesTensor(
        tensorExtractorHelper.sparseTensor,
        Shape(
            shape: tensorExtractorHelper.shape,
            size: tensorExtractorHelper.size,
            dimCount: []),
        tensorExtractorHelper.sparseValue!,
        tensorOrder,
      );
    } else {
      return DenseTensor(
        tensorExtractorHelper.flatTensor,
        Shape(
          shape: tensorExtractorHelper.shape,
          size: tensorExtractorHelper.size,
          dimCount: [],
        ),
        tensorOrder,
      );
    }
  }

  static void _columnMajorOrder<T extends Object>(
      List value, TensorExtractorHelper tensorExtractorHelper,
      {int index = 0}) {
    if (value.isEmpty) {
      tensorExtractorHelper.addColumnTensorElements(value, index);
    } else if (value.first is List) {
      if (value.first.isEmpty || value.first.first is! List) {
        for (List val in value) {
          tensorExtractorHelper.addDim(index: index, value: val.length);
        }

        tensorExtractorHelper.addColumnTensorElements(value, index);
      } else {
        tensorExtractorHelper.addDim(index: index, value: value.first.length);
        for (int i = 0; i < value.length; i++) {
          _columnMajorOrder(value[i], tensorExtractorHelper, index: index + 1);
        }
      }
    }
  }

  static void _rowMajorOrder<T extends Object>(
      List value, TensorExtractorHelper tensorExtractorHelper,
      {int index = 0}) {
    if (value.isEmpty) {
      tensorExtractorHelper.addRowTensorElements(value, index);
    } else if (value.first is! List) {
      tensorExtractorHelper.addRowTensorElements(value, index);
    } else {
      for (int i = 0; i < value.length; i++) {
        tensorExtractorHelper.addDim(index: index, value: value[i].length);
        if (value[i].isNotEmpty) {
          _rowMajorOrder(value[i], tensorExtractorHelper, index: index + 1);
        }
      }
    }
  }

  // static List<List<int>> transformFlatIndecesToShape(
  //     List<int> indeces, List<int> shape) {}
}
