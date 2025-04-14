import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:rigz/Model/productModel.dart';
import 'package:rigz/View/productDetail_Screen.dart';

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
              padding: EdgeInsets.all(15),
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
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image);
                        },
                      ),
                    ),
                  ),
                  Spacer(),
                  //name
                  Text(product.title),
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
                ],
              ),
            ),
          ),
          if (product.discount != Decimal.parse("0"))
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage("assets/Discount.png"),
              child: Text("${product.discount}%"),
            ),
        ],
      ),
    );
  }
}
