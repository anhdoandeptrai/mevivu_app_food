import 'package:get/get.dart';
import 'package:mevivuapp/untils/hive_helper.dart';
import '../models/recipe_model.dart';

class SavedController extends GetxController {
  final RxList<Recipe> savedRecipes = <Recipe>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedRecipes();
  }

  void loadSavedRecipes() {
    savedRecipes.value = HiveHelper.getSavedRecipes();
  }
}
