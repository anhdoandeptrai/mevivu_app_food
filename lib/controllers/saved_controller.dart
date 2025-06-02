import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/recipe_model.dart';

class SavedController extends GetxController {
  final RxList<Recipe> savedRecipes = <Recipe>[].obs;
  final String savedRecipesBoxName = 'savedRecipes';

  @override
  void onInit() {
    super.onInit();
    _initializeHive();
    loadSavedRecipes();
  }

  Future<void> _initializeHive() async {
    try {
      if (!Hive.isAdapterRegistered(RecipeAdapter().typeId)) {
        Hive.registerAdapter(RecipeAdapter());
      }
      await Hive.openBox<Recipe>(savedRecipesBoxName);
    } catch (e, stackTrace) {
      print('Error initializing Hive: $e, StackTrace: $stackTrace');
      Get.snackbar(
        'Lỗi khởi tạo',
        'Không thể khởi tạo cơ sở dữ liệu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadSavedRecipes() async {
    try {
      final box = await Hive.openBox<Recipe>(savedRecipesBoxName);
      savedRecipes.assignAll(box.values.toList());
    } catch (e) {
      // handle error
    }
  }

  Future<void> toggleSave(Recipe recipe) async {
    if (recipe.idMeal == null) {
      Get.snackbar('Lỗi', 'Công thức không có ID hợp lệ');
      return;
    }

    try {
      final box = await Hive.openBox<Recipe>(savedRecipesBoxName);
      final existingRecipes =
          box.values.where((r) => r.idMeal == recipe.idMeal).toList();

      if (existingRecipes.isNotEmpty) {
        for (var existingRecipe in existingRecipes) {
          await box.delete(existingRecipe.key);
        }
        Get.snackbar(
          'Đã xóa',
          'Công thức đã được xóa khỏi danh sách yêu thích',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 1),
        );
      } else {
        final newRecipe = Recipe.fromJson(recipe.toJson());
        await box.add(newRecipe);
        Get.snackbar(
          'Đã lưu',
          'Công thức đã được lưu vào danh sách yêu thích',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 1),
        );
      }
      await loadSavedRecipes();
    } catch (e, stackTrace) {
      print('Error toggling save status: $e, StackTrace: $stackTrace');
      Get.snackbar(
        'Lỗi',
        'Không thể thay đổi trạng thái lưu: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    }
  }
}
