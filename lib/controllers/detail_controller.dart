import 'package:get/get.dart';
import '../models/recipe_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'saved_controller.dart';

class DetailController extends GetxController {
  var selectedTabIndex = 0.obs;
  var isLoading = false.obs;
  var currentRecipe = Recipe().obs;

  // Observable to track if the recipe is saved
  RxBool isSaved = false.obs;

  final SavedController savedController = Get.find<SavedController>();

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> openVideo(String videoUrl) async {
    if (videoUrl.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Không có video cho công thức này',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Uri uri = Uri.parse(videoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'Lỗi',
        'Không thể mở video: $videoUrl',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void fetchFullRecipeDetails(String id) async {
    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          final recipeData = data['meals'][0];
          currentRecipe.value = Recipe.fromJson(recipeData);
          print('Fetched complete recipe data with ingredients!');
        }
      }
    } catch (e) {
      print('Error fetching recipe details: $e');
    } finally {
      isLoading(false);
    }
  }

  // Khi muốn lưu hoặc bỏ lưu, chỉ cần gọi:
  // savedController.toggleSave(currentRecipe.value);

  // Add this method to check if a recipe is saved
  void checkIfSaved(String idMeal) {
    // Implement your logic here, for example:
    // isSaved.value = savedRecipes.contains(idMeal);
  }

  // Add this method to toggle save/unsave for a recipe
  void toggleSave(Recipe recipe) {
    // Implement your save/unsave logic here
    // For example:
    if (isSaved.value) {
      // Remove from saved list
      removeRecipeFromSaved(recipe);
      isSaved.value = false;
    } else {
      // Add to saved list
      addRecipeToSaved(recipe);
      isSaved.value = true;
    }
  }

  // Dummy methods for demonstration, replace with your actual logic
  void addRecipeToSaved(Recipe recipe) {
    // Add recipe to saved list
  }

  void removeRecipeFromSaved(Recipe recipe) {
    // Remove recipe from saved list
  }
}
