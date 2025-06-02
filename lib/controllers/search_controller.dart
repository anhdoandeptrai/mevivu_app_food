import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/recipe_model.dart';

class SearchController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Recipe> searchResults = <Recipe>[].obs;
  RxList<String> searchSuggestions = <String>[].obs;
  RxList<String> recentSearches = <String>[].obs;

  // Track selected recipe
  Rx<Recipe?> selectedRecipe = Rx<Recipe?>(null);
  RxBool isDetailView = false.obs;

  // Filter state
  RxString selectedCategory = "".obs;
  RxString selectedIngredient = "".obs;
  RxString selectedArea = "".obs;

  // Available filter options
  RxList<String> categories = <String>[].obs;
  RxList<String> ingredients = <String>[].obs;
  RxList<String> areas = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with dummy values first to prevent null errors
    initializeFilterData();

    // Then load actual data
    loadRecentSearches();
    loadSuggestions();
    fetchCategories();
    fetchAreas();
    fetchIngredients();
  }

  // Add this method to ensure filter data is initialized
  void initializeFilterData() {
    // Default categories if API fails
    if (categories.isEmpty) {
      categories.value = ['Danh mục 1', 'Danh mục 2', 'Danh mục 3'];
    }

    // Default ingredients if API fails
    if (ingredients.isEmpty) {
      ingredients.value = ['Thịt gà', 'Thịt heo', 'Ức gà'];
    }

    // Default areas if API fails
    if (areas.isEmpty) {
      areas.value = ['TP.HCM', 'Bình Phước', 'Long An'];
    }
  }

  void loadRecentSearches() {
    // This would typically be loaded from local storage
    recentSearches.value = [
      'Pizza hến xào',
      'Pipị đứt lỗ',
      'Pizza thơm',
      'Pizza hải sản',
      'Pizza thịt xông khói'
    ];
  }

  void loadSuggestions() {
    // Initially show recent searches as suggestions
    searchSuggestions.value = recentSearches;
  }

  // Fetch real categories from API
  void fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?c=list'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          final categoryList = data['meals'] as List;
          categories.value =
              categoryList.map((e) => e['strCategory'] as String).toList();
        }
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  // Fetch real areas from API
  void fetchAreas() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?a=list'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          final areaList = data['meals'] as List;
          areas.value = areaList.map((e) => e['strArea'] as String).toList();
        }
      }
    } catch (e) {
      print('Error fetching areas: $e');
    }
  }

  // Fetch real ingredients from API
  void fetchIngredients() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?i=list'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          final ingredientList = data['meals'] as List;
          ingredients.value = ingredientList
              .map((e) => e['strIngredient'] as String)
              .take(20) // Limit to 20 ingredients
              .toList();
        }
      }
    } catch (e) {
      print('Error fetching ingredients: $e');
    }
  }

  void searchRecipes(String query) async {
    // Reset view to list mode whenever a new search is performed
    isDetailView.value = false;
    selectedRecipe.value = null;

    if (query.isEmpty) {
      searchSuggestions.value = recentSearches;
      searchResults.clear();
      return;
    }

    try {
      isLoading(true);

      // First, filter suggestions based on query
      searchSuggestions.value = recentSearches
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Then, search for recipes using TheMealDB API
      final response = await http.get(
        Uri.parse(
            'https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          final recipesList = data['meals'] as List;
          searchResults.value =
              recipesList.map((e) => Recipe.fromJson(e)).toList();
        } else {
          searchResults.clear();
        }
      }
    } catch (e) {
      print('Error searching recipes: $e');
      searchResults.clear();
    } finally {
      isLoading(false);
    }

    // Add to recent searches if not already there
    if (!recentSearches.contains(query) && query.isNotEmpty) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 5) {
        recentSearches.removeLast();
      }
      // Save recent searches to local storage here
    }
  }

  void selectRecipe(Recipe recipe) {
    // Thay vì hiển thị inline, chuyển hướng đến màn hình detail
    Get.toNamed('/detail', arguments: recipe);

    // Cách cũ hiển thị inline (comment lại)
    // selectedRecipe.value = recipe;
    // isDetailView.value = true;
  }

  void backToList() {
    isDetailView.value = false;
    selectedRecipe.value = null;
  }

  Future<void> fetchRecipeDetails(String id) async {
    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          final recipeData = data['meals'][0];
          selectedRecipe.value = Recipe.fromJson(recipeData);
        }
      }
    } catch (e) {
      print('Error fetching recipe details: $e');
    } finally {
      isLoading(false);
    }
  }

  void filterRecipes() async {
    // Reset view to list mode whenever filtering is applied
    isDetailView.value = false;
    selectedRecipe.value = null;

    try {
      isLoading(true);

      // Default search if no filters are selected
      if (selectedCategory.isEmpty &&
          selectedArea.isEmpty &&
          selectedIngredient.isEmpty) {
        final response = await http.get(
          Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s='),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['meals'] != null) {
            final recipesList = data['meals'] as List;
            searchResults.value =
                recipesList.map((e) => Recipe.fromJson(e)).toList();
          } else {
            searchResults.clear();
          }
        }
        return;
      }

      // Apply filter based on what's selected
      String endpoint = 'https://www.themealdb.com/api/json/v1/1/filter.php';
      Map<String, String> queryParams = {};

      if (selectedCategory.isNotEmpty) {
        queryParams['c'] = selectedCategory.value;
      } else if (selectedArea.isNotEmpty) {
        queryParams['a'] = selectedArea.value;
      } else if (selectedIngredient.isNotEmpty) {
        queryParams['i'] = selectedIngredient.value;
      }

      final uri = Uri.parse(endpoint).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          final recipesList = data['meals'] as List;
          searchResults.value =
              recipesList.map((e) => Recipe.fromJson(e)).toList();
        } else {
          searchResults.clear();
        }
      }
    } catch (e) {
      print('Error filtering recipes: $e');
      // Show an error message to the user
      Get.snackbar(
        'Lỗi',
        'Không thể tải dữ liệu lọc. Vui lòng thử lại sau.',
        snackPosition: SnackPosition.BOTTOM,
      );
      searchResults.clear();
    } finally {
      isLoading(false);
    }
  }

  void resetFilters() {
    selectedCategory.value = "";
    selectedIngredient.value = "";
    selectedArea.value = "";
  }
}
