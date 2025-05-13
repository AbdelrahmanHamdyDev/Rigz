import 'package:flutter/material.dart';
import 'package:rigz/Model/productModel.dart';
import 'package:rigz/View/Products_Screen.dart';
import 'package:rigz/View/widget/productCard_Widget.dart';

class productShowcase_Slider extends StatelessWidget {
  const productShowcase_Slider({
    super.key,
    required this.title,
    required this.products,
  });

  final String title;
  final Future<List<productModel>> products;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<productModel>>(
      future: products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error while fetching the data ${snapshot.error}"),
          );
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center();
        }
        final products = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            spacing: 10,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => Scaffold(
                                appBar: AppBar(title: Text(title)),
                                body: Products_Screen(
                                  title: title,
                                  products: products,
                                ),
                              ),
                        ),
                      );
                    },
                    child: const Text("View All"),
                  ),
                ],
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (products.length < 10) ? products.length : 5,
                  itemBuilder:
                      (context, index) =>
                          productCard_Widget(product: products[index]),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: const Divider(),
              ),
            ],
          ),
        );
      },
    );
  }
}
