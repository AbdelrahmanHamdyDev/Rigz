import 'package:flutter/material.dart';
import 'package:rigz/Model/productModel.dart';

class cartProduct_Widget extends StatefulWidget {
  const cartProduct_Widget({super.key, required this.product});

  final productModel product;

  @override
  State<cartProduct_Widget> createState() => _cartProduct_WidgetState();
}

class _cartProduct_WidgetState extends State<cartProduct_Widget> {
  int _cartQuantity = 1;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      margin: EdgeInsets.all(10),
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
                  image: NetworkImage(widget.product.imageUrl[0]),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.product.title,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Spacer(),
            Card(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_cartQuantity > 1) {
                          _cartQuantity--;
                        }
                        if (_cartQuantity == 1) {
                          //remove the product from the card
                          setState(() {});
                        }
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text(
                    _cartQuantity.toString(),
                    style: TextStyle(fontSize: 22),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_cartQuantity <= widget.product.stockAmount) {
                          _cartQuantity++;
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "This is the maximum amount in the stock",
                              ),
                            ),
                          );
                        }
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
