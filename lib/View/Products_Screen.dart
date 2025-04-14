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
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: products.length,
      itemBuilder:
          (context, index) => productCard_Widget(product: products[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (products.isEmpty)
        ? Scaffold(
          appBar: AppBar(title: Text(title)),
          body: FutureBuilder(
            future: HomeViewmodel().category_Products(title),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error while Feathing the Data"));
              }
              if (snapshot.data!.isEmpty) {
                return Center(child: Text("No Data Avaliable"));
              }
              var snapData = snapshot.data!;
              return mainWidgets(snapData);
            },
          ),
        )
        : mainWidgets(products);
  }
}
