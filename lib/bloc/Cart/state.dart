import 'package:rigz/Model/CartModel.dart';

class CartState {
  final List<CartModel> products;
  CartState({required this.products});

  CartState copyWith({List<CartModel>? products}) {
    return CartState(products: products ?? this.products);
  }
}
