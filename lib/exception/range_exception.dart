import 'package:dtensor/model/model.dart';

class RangeException implements Exception {
  final String operation;
  final int min, max;

  RangeException(this.operation, this.min, this.max);

  @override
  String toString() {
    return '${operation} should be between ${min} and ${max}';
  }
}
