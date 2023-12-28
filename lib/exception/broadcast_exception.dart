import 'package:dtensor/model/model.dart';

class BroadcastException implements Exception {
  final Shape leftShape, rightShape2;

  BroadcastException(this.leftShape, this.rightShape2);

  @override
  String toString() {
    return 'The shape ${leftShape.shape} can not be broadcast to shape ${rightShape2.shape}';
  }
}
