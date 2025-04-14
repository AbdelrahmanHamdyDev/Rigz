import 'package:rigz/Model/CategoryModel.dart';
import 'package:rigz/Model/productModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeViewmodel {
  final supabase = Supabase.instance.client;
  Future<List<CategoryModel>> categories() async {
    final response = await supabase.from('categories').select();
    return response.map((element) => CategoryModel.fromJson(element)).toList();
  }

  Future<List<productModel>> category_Products(String cat) async {
    final response = await supabase
        .from('Allproducts')
        .select()
        .eq("categories", cat);
    return response.map((element) => productModel.fromJson(element)).toList();
  }

  Future<List<productModel>> search_ForProduct(String UserText) async {
    final response = await supabase
        .from('Allproducts')
        .select()
        .ilike('title', '%$UserText%');
    return response.map((element) => productModel.fromJson(element)).toList();
  }

  Future<List<productModel>> special_Offers() async {
    final response = await supabase
        .from('Allproducts')
        .select()
        .gte('discount', 10);
    return response.map((element) => productModel.fromJson(element)).toList();
  }

  Future<List<productModel>> almost_Gone() async {
    final response = await supabase
        .from('Allproducts')
        .select()
        .lte('stockAmount', 10);
    return response.map((element) => productModel.fromJson(element)).toList();
  }

  Future<List<productModel>> new_Arrive() async {
    final response = await supabase
        .from('Allproducts')
        .select()
        .order('date', ascending: false)
        .limit(10);

    return response.map((element) => productModel.fromJson(element)).toList();
  }
}
