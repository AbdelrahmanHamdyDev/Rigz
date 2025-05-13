import 'package:flutter/material.dart';
import 'package:rigz/Model/productModel.dart';
import 'package:rigz/View/widget/productCard_Widget.dart';
import 'package:rigz/ViewModel/home_ViewModel.dart';

class Products_Screen extends StatelessWidget {
  const Products_Screen({
    super.key,
    required this.title,
    required this.products,
  });

  final String title;
  final List<productModel> products;

  Widget mainWidgets(List<productModel> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder:
          (context, index) =>
              FittedBox(child: productCard_Widget(product: products[index])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (products.isEmpty)
        ? Scaffold(
          appBar: (title != "Favorites") ? AppBar(title: Text(title)) : null,
          body: SafeArea(
            child: FutureBuilder(
              future: HomeViewmodel().category_Products(title),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error while Feathing the Data"),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return const Center(child: Text("No Data Avaliable"));
                }
                var snapData = snapshot.data!;
                return mainWidgets(snapData);
              },
            ),
          ),
        )
        : mainWidgets(products);
  }
}
