import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/recipe_model.dart';

class NewsController extends GetxController {
  RxList<Recipe> newsRecipes = <Recipe>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s='));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        newsRecipes.assignAll(
          (data['meals'] as List).map((e) => Recipe.fromJson(e)).toList(),
        );
      }
    }
  }
}
