import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:rigz/Model/productModel.dart';
import 'package:rigz/View/widget/cartProduct_Widget.dart';

class cartScreen extends StatelessWidget {
  final List<productModel> dummyData = [
    productModel(
      id: 1,
      discount: Decimal.parse("10"),
      imageUrl: [
        "https://m.media-amazon.com/images/I/61ya54DiG8L._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/711PF9oVwvL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71OebiSOsRL._AC_SL1500_.jpg",
      ],
      title: "RTX2060 zotiac",
      description: "This is the most unique Rtx card in 2020",
      stockAmount: 10,
      price: Decimal.parse("21.20"),
    ),
    productModel(
      id: 2,
      discount: Decimal.parse("20"),
      imageUrl: [
        "https://m.media-amazon.com/images/I/61lbscDvs4L._AC_SX450_.jpg",
        "https://m.media-amazon.com/images/I/61VTIwBT0kL._AC_SX450_.jpg",
        "https://m.media-amazon.com/images/I/5104hH2LRbL.__AC_SX300_SY300_QL70_ML2_.jpg",
      ],
      title: "intel i5 12400k",
      description:
          "This is the budget processor that help you in the most of the day's tasks",
      stockAmount: 2,
      price: Decimal.parse("199.99"),
    ),
    productModel(
      id: 3,
      discount: Decimal.parse("0"),
      imageUrl: [
        "https://m.media-amazon.com/images/I/81I7KU9EojL._SX342_.jpg",
        "https://m.media-amazon.com/images/I/71K6SobqL6L._SX342_.jpg",
        "https://m.media-amazon.com/images/I/41gL6mmUx2L._SX300_SY300_QL70_FMwebp_.jpg",
      ],
      title: "ROG Ally",
      description:
          "this is the most popular handheld console that run in windows, have hoolyeffect joysticks and 2 fans to controll the heat with 2 year warrenty on it",
      stockAmount: 1,
      price: Decimal.parse("2000.01"),
    ),
    productModel(
      id: 4,
      discount: Decimal.parse("2"),
      imageUrl: [
        "https://m.media-amazon.com/images/I/61Ok-HhGQIL._AC_SX425_.jpg",
        "https://m.media-amazon.com/images/I/71X4f-XFOxL._AC_SX355_.jpg",
        "https://m.media-amazon.com/images/I/91buE992yIL.__AC_SX300_SY300_QL70_FMwebp_.jpg",
      ],
      title: "ASUS B540",
      description: "this motherboard is good",
      stockAmount: 100,
      price: Decimal.parse("200.10"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //products
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              itemCount: dummyData.length,
              itemBuilder:
                  (context, index) =>
                      cartProduct_Widget(product: dummyData[index]),
            ),
          ),
          //pay button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios),
              iconAlignment: IconAlignment.end,
              label: const Text("Go To Pay"),
            ),
          ),
        ],
      ),
    );
  }
}
