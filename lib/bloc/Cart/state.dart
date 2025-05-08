import 'package:rigz/Model/CartModel.dart';

class productsState {
  final List<CartModel> products;
  productsState({required this.products});

  productsState copyWith({List<CartModel>? products}) {
    return productsState(products: products ?? this.products);
  }
}
