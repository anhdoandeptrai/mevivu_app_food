import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/recipe_model.dart';

class HomeController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<String> categories = <String>[].obs;
  RxList<Recipe> recipes = <Recipe>[].obs;
  RxList<Recipe> featuredRecipes = <Recipe>[].obs;
  final String recipesBoxName = 'recipes';
  final String featuredRecipesBoxName = 'featuredRecipes';

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    loadRecipes();
    loadFeaturedRecipes();
  }

  void fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categoryList = data['categories'] as List;
        categories.value =
            categoryList.map((e) => e['strCategory'] as String).toList();
      }
    } catch (e) {
      print('Error fetching categories: $e');
      // Fallback categories
      categories.value = [
        'Breakfast',
        'Lunch',
        'Dinner',
        'Dessert',
        'Vegetarian',
        'Seafood',
        'Chicken',
        'Beef'
      ];
    }
  }

  void loadRecipes() async {
    try {
      isLoading(true);
      // Try to load from Hive first
      if (Hive.isBoxOpen(recipesBoxName) ||
          // ignore: unnecessary_null_comparison
          await Hive.openBox<Recipe>(recipesBoxName) != null) {
        final box = Hive.box<Recipe>(recipesBoxName);
        if (box.isNotEmpty) {
          recipes.value = box.values.toList();
          isLoading(false);
          return;
        }
      }

      // If no data in Hive, fetch from API
      await fetchRecipes();
    } catch (e) {
      print('Error loading recipes: $e');
      recipes.value = getSampleRecipes();
      isLoading(false);
    }
  }

  Future<void> fetchRecipes() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=b'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final recipesList = data['meals'] as List;
        final fetchedRecipes =
            recipesList.map((e) => Recipe.fromJson(e)).toList();
        recipes.value = fetchedRecipes;

        // Save to Hive
        await saveRecipesToHive(fetchedRecipes);
      }
    } catch (e) {
      print('Error fetching recipes: $e');
      recipes.value = getSampleRecipes();
    } finally {
      isLoading(false);
    }
  }

  Future<void> saveRecipesToHive(List<Recipe> recipesToSave) async {
    try {
      final box = await Hive.openBox<Recipe>(recipesBoxName);
      await box.clear();
      for (var recipe in recipesToSave) {
        await box.add(recipe);
      }
    } catch (e) {
      print('Error saving recipes to Hive: $e');
    }
  }

  void loadFeaturedRecipes() async {
    try {
      // Try to load from Hive first
      if (Hive.isBoxOpen(featuredRecipesBoxName) ||
          // ignore: unnecessary_null_comparison
          await Hive.openBox<Recipe>(featuredRecipesBoxName) != null) {
        final box = Hive.box<Recipe>(featuredRecipesBoxName);
        if (box.isNotEmpty) {
          featuredRecipes.value = box.values.toList();
          return;
        }
      }

      // If no data in Hive, fetch from API
      await fetchFeaturedRecipes();
    } catch (e) {
      print('Error loading featured recipes: $e');
      featuredRecipes.value = getSampleRecipes();
    }
  }

  Future<void> fetchFeaturedRecipes() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=c'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final recipesList = data['meals'] as List;
        final fetchedRecipes =
            recipesList.map((e) => Recipe.fromJson(e)).toList();
        featuredRecipes.value = fetchedRecipes;

        // Save to Hive
        await saveFeaturedRecipesToHive(fetchedRecipes);
      }
    } catch (e) {
      print('Error fetching featured recipes: $e');
      featuredRecipes.value = getSampleRecipes();
    }
  }

  Future<void> saveFeaturedRecipesToHive(List<Recipe> recipesToSave) async {
    try {
      final box = await Hive.openBox<Recipe>(featuredRecipesBoxName);
      await box.clear();
      for (var recipe in recipesToSave) {
        await box.add(recipe);
      }
    } catch (e) {
      print('Error saving featured recipes to Hive: $e');
    }
  }

  List<Recipe> getSampleRecipes() {
    return [
      Recipe(
        idMeal: '1',
        strMeal: 'Cách chiên trứng một cách cung phu',
        strCategory: 'Eggs',
        strArea: 'Vietnamese',
        strMealThumb:
            'https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg',
      ),
      Recipe(
        idMeal: '2',
        strMeal: 'Món trứng chiên đặc biệt',
        strCategory: 'Eggs',
        strArea: 'Vietnamese',
        strMealThumb:
            'https://www.themealdb.com/images/media/meals/uttuxy1487140173.jpg',
      ),
    ];
  }
}
