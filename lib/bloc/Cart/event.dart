import 'package:rigz/Model/CartModel.dart';

abstract class CartEvent {}

class Addproduct extends CartEvent {
  final CartModel product;
  Addproduct(this.product);
}

class IncrementproductOrder extends CartEvent {
  final CartModel product;
  IncrementproductOrder(this.product);
}

class DecrementproductOrder extends CartEvent {
  final CartModel product;
  DecrementproductOrder(this.product);
}

class PayproductOrder extends CartEvent {
  PayproductOrder();
}

class ClearproductOrder extends CartEvent {
  ClearproductOrder();
}
