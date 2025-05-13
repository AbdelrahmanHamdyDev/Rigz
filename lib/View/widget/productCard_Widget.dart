import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rigz/Model/CartModel.dart';
import 'package:rigz/Model/productModel.dart';
import 'package:rigz/View/productDetail_Screen.dart';
import 'package:rigz/bloc/Cart/bloc.dart';
import 'package:rigz/bloc/Cart/event.dart' as cart_event;
import 'package:rigz/bloc/Fav/bloc.dart';
import 'package:rigz/bloc/Fav/event.dart' as fav_event;
import 'package:rigz/bloc/Fav/state.dart';

class productCard_Widget extends StatelessWidget {
  const productCard_Widget({super.key, required this.product});

  final productModel product;

  @override
  Widget build(BuildContext context) {
    Decimal discountPrice =
        (product.price *
                (Decimal.fromInt(100) - product.discount) /
                Decimal.fromInt(100))
            .toDecimal();
    return InkWell(
      onTap:
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => productDetail_Screen(product: product),
            ),
          ),
      child: Stack(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //image
                  SizedBox(
                    width: 200,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        product.imageUrl[0],
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  //name
                  SizedBox(
                    width: 100,
                    child: Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  //price
                  Row(
                    spacing: 20,
                    children: [
                      Text(
                        "${product.price}\$",
                        style: TextStyle(
                          decoration:
                              (product.discount != Decimal.parse("0"))
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                      if (product.discount != Decimal.parse("0"))
                        Text("$discountPrice\$"),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    spacing: 20,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_bag),
                        label: const Text("Add To Card"),
                        onPressed: () {
                          context.read<CartBloc>().add(
                            cart_event.Addproduct(
                              CartModel(product: product, quantity: 1),
                            ),
                          );
                          print("Done");
                        },
                      ),
                      BlocSelector<FavBloc, FavState, bool>(
                        selector:
                            (state) =>
                                state.products.any((p) => p.id == product.id),
                        builder: (context, bool is_Fav) {
                          return IconButton(
                            onPressed: () {
                              context.read<FavBloc>().add(
                                fav_event.toogleProductFav(product),
                              );
                            },
                            icon: Icon(
                              (is_Fav) ? Icons.favorite : Icons.favorite_border,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (product.discount != Decimal.parse("0"))
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage("assets/Discount.png"),
              child: Text("${product.discount}%"),
            ),
        ],
      ),
    );
  }
}
