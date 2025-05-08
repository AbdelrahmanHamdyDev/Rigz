import 'package:rigz/Model/productModel.dart';

class CartModel {
  CartModel({required this.product, required this.quantity});
  final productModel product;
  int quantity;
}
