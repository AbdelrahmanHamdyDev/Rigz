import 'package:decimal/decimal.dart';

class productModel {
  productModel({
    required this.id,
    required this.title,
    required this.description,
    required this.stockAmount,
    required this.price,
    required this.discount,
    required this.imageUrl,
  });

  final int id;
  final String title;
  final String description;
  final int stockAmount;
  final Decimal price;
  final Decimal discount;
  final List<dynamic> imageUrl;

  factory productModel.fromJson(Map<String, dynamic> jsonData) {
    return productModel(
      id: jsonData['id'],
      title: jsonData['title'],
      description: jsonData['description'],
      price: Decimal.parse(jsonData['price'].toString()),
      discount: Decimal.parse(jsonData['discount'].toString()),
      stockAmount: jsonData['stockAmount'],
      imageUrl: jsonData['imageUrl'],
    );
  }
}
