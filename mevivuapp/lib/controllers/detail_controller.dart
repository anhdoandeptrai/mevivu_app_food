import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/recipe_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Update the DetailController class to start with ingredients tab selected
class DetailController extends GetxController {
  RxBool isSaved = false.obs;
  RxInt selectedTabIndex = 0.obs; // Default tab is ingredients (0)
  RxBool isLoading = false.obs;
  Rx<Recipe?> currentRecipe = Rx<Recipe?>(null);
  final String savedRecipesBoxName = 'savedRecipes';

  @override
  void onInit() {
    super.onInit();
    // Initialize controller state
  }

  void checkIfSaved(String id) async {
    try {
      final box = await Hive.openBox<Recipe>(savedRecipesBoxName);
      isSaved.value = box.values.any((recipe) => recipe.idMeal == id);
    } catch (e) {
      print('Error checking if recipe is saved: $e');
    }
  }

  void toggleSave(Recipe recipe) async {
    try {
      final box = await Hive.openBox<Recipe>(savedRecipesBoxName);

      if (isSaved.value) {
        // Remove from saved recipes
        final recipesToDelete =
            box.values.where((r) => r.idMeal == recipe.idMeal);
        for (var recipeToDelete in recipesToDelete) {
          final key = recipeToDelete.key;
          await box.delete(key);
        }

        Get.snackbar(
          'Đã xóa',
          'Công thức đã được xóa khỏi danh sách yêu thích',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Save recipe
        await box.add(recipe);

        Get.snackbar(
          'Đã lưu',
          'Công thức đã được lưu vào danh sách yêu thích',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      isSaved.toggle();
    } catch (e) {
      print('Error toggling save status: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể thay đổi trạng thái lưu',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

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
}
