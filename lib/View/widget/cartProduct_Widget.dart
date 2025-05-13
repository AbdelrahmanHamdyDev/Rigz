import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rigz/Model/CartModel.dart';
import 'package:rigz/bloc/Cart/bloc.dart';
import 'package:rigz/bloc/Cart/event.dart' as cart_event;

class cartProduct_Widget extends StatelessWidget {
  const cartProduct_Widget({super.key, required this.productCart});

  final CartModel productCart;

  @override
  Widget build(BuildContext context) {
    int _cartQuantity = productCart.quantity;
    return Card(
      elevation: 20,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          spacing: 10,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(productCart.product.imageUrl[0]),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Text(
                productCart.product.title,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Color(0XFF1E1E1E)),
                  BoxShadow(offset: Offset(2, 2), blurRadius: 4),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<CartBloc>().add(
                          cart_event.DecrementproductOrder(productCart),
                        );
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5E5E5E),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Icon(Icons.remove, size: 10),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Text(
                      _cartQuantity.toString(),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        context.read<CartBloc>().add(
                          cart_event.IncrementproductOrder(productCart),
                        );
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5E5E5E),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Icon(Icons.add, size: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
