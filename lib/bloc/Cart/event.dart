import 'package:rigz/Model/CartModel.dart';

abstract class ProductEvent {}

class Addproduct extends ProductEvent {
  final CartModel product;
  Addproduct(this.product);
}

class IncrementproductOrder extends ProductEvent {
  final CartModel product;
  IncrementproductOrder(this.product);
}

class DecrementproductOrder extends ProductEvent {
  final CartModel product;
  DecrementproductOrder(this.product);
}

class ClearproductOrder extends ProductEvent {
  final CartModel product;
  ClearproductOrder(this.product);
}
