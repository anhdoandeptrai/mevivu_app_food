import 'package:hive/hive.dart';
import '../models/recipe_model.dart';

class HiveHelper {
  static Box<Recipe>? _box;

  static Future<void> init() async {
    _box = await Hive.openBox<Recipe>('recipesBox');
  }

  static List<Recipe> getRecipes() {
    return _box?.values.toList() ?? [];
  }

  static void saveRecipe(Recipe recipe) {
    _box?.add(recipe);
  }

  static void updateRecipe(Recipe recipe) {
    if (recipe.idMeal != null) {
      final existing = _box?.values.firstWhere(
        (r) => r.idMeal == recipe.idMeal,
        orElse: () => Recipe(idMeal: recipe.idMeal),
      );
      if (existing != null) {
        existing.strMeal = recipe.strMeal;
        existing.strMealThumb = recipe.strMealThumb;
        existing.strInstructions = recipe.strInstructions;
        existing.strArea = recipe.strArea;
        existing.strCategory = recipe.strCategory;
        existing.save();
      } else {
        saveRecipe(recipe);
      }
    }
  }

  static List<Recipe> getSavedRecipes() {
    return _box?.values.toList() ?? [];
  }

  static bool isRecipeSaved(String idMeal) {
    return _box?.values.any((recipe) => recipe.idMeal == idMeal) ?? false;
  }

  static void deleteRecipe(String idMeal) {
    final recipe = _box?.values.firstWhere((r) => r.idMeal == idMeal);
    if (recipe != null) {
      recipe.delete();
    }
  }
}