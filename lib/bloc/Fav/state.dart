import 'package:rigz/Model/productModel.dart';

class FavState {
  final List<productModel> products;
  FavState({required this.products});

  FavState copyWith({List<productModel>? products}) {
    return FavState(products: products ?? this.products);
  }
}
