import 'package:flutter/material.dart';
import 'package:rigz/Model/CategoryModel.dart';
import 'package:rigz/View/Products_Screen.dart';

class category_Widget extends StatelessWidget {
  const category_Widget({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) =>
                    Products_Screen(title: category.title, products: []),
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 60),
              child: Card(
                elevation: 10,
                color: Colors.blueGrey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 140,
              width: 140,
              child: Image.network(category.imageUrl, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
