
import 'package:dtensor/model/model.dart';

class NotSupportedOperationType implements Exception {
  final String operation;
  final Object type;

  NotSupportedOperationType(this.operation, this.type);

  @override
  String toString() {
    return 'The Operation ${operation} is not supported for type ${type}';
  }
}
