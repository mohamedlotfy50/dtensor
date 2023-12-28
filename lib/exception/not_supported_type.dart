
import 'package:dtensor/model/model.dart';

class NotSupportedType implements Exception {
  final String type;

  NotSupportedType(this.type);

  @override
  String toString() {
    return 'The  type ${type} is not supported';
  }
}
