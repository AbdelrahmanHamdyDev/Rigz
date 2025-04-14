class CategoryModel {
  CategoryModel({required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;

  factory CategoryModel.fromJson(Map<String, dynamic> jsonData) {
    return CategoryModel(
      title: jsonData['title'],
      imageUrl: jsonData['imageUrl'],
    );
  }
}
