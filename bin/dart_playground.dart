import 'dart:async';
import 'package:uuid/uuid.dart';

class Cake {
  final String flavor;

  Cake(this.flavor);
}

class Order {
  final String uuid = Uuid().v4();
  final String flavor;
  final DateTime orderedAt = DateTime.now();

  Order({required this.flavor});

  @override
  String toString() {
    return "Order ID: $uuid | flavor: $flavor";
  }
}

void main() {
  List<String> allowedFlavors = ["chocolate", "banana", "cenoura"];

  var controller = StreamController();
  controller.sink.add(Order(flavor: "chocolate"));
  controller.sink.add(Order(flavor: "coconut"));
  controller.sink.add(Order(flavor: "shit"));
  controller.sink.add(Order(flavor: "banana"));

  final cakeCooker = StreamTransformer.fromHandlers(
    handleData: (flavor, sink) {
      if (allowedFlavors.contains(flavor)) {
        sink.add(Cake(flavor.toString()));
      } else {
        sink.addError("Can't bake that $flavor flavor, sorry.");
      }
    },
  );

  controller.stream.map((order) => order.flavor).transform(cakeCooker).listen(
    (event) {
      print(event);
    },
    onError: (error) => print('error: $error'),
  );
}
