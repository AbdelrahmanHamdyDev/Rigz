import 'package:rigz/Model/productModel.dart';

abstract class FavEvent {}

class toogleProductFav extends FavEvent {
  final productModel product;
  toogleProductFav(this.product);
}

class ClearFavList extends FavEvent {
  ClearFavList();
}
