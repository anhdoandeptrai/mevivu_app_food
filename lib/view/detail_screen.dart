import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mevivuapp/untils/app_theme.dart';
import '../controllers/detail_controller.dart';
import '../controllers/saved_controller.dart';
import '../models/recipe_model.dart';

class DetailScreen extends StatelessWidget {
  final DetailController controller = Get.put(DetailController());
  final SavedController savedController = Get.find<SavedController>();
  final Recipe recipe = Get.arguments as Recipe;

  @override
  Widget build(BuildContext context) {
    // Ngay khi khởi tạo màn hình, fetch dữ liệu đầy đủ
    controller.fetchFullRecipeDetails(recipe.idMeal!);
    controller.checkIfSaved(recipe.idMeal!);

    return Scaffold(
      extendBody: true,
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator(color: AppTheme.primary500))
          : _buildDetailContent(context)),
      // Không cần bottom navigation bar vì đây là trang chi tiết
    );
  }

  Widget _buildDetailContent(BuildContext context) {
    // Sử dụng recipe từ controller để đảm bảo dữ liệu đầy đủ
    final Recipe fullRecipe = controller.currentRecipe.value;

    // Extract ingredients and measures từ dữ liệu đầy đủ
    final ingredients = _extractIngredientsAndMeasures(fullRecipe);

    return CustomScrollView(
      slivers: [
        // Hero Header Image with Title Overlay
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppTheme.primary900,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Image.network(
                  fullRecipe.strMealThumb ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.neutral200,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: AppTheme.neutral500,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primary900.withOpacity(0.8),
                        AppTheme.primary900.withOpacity(0.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Text Overlay
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Text(
                        "It's that",
                        style: TextStyle(
                          color: AppTheme.neutral50,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "simple.",
                        style: TextStyle(
                          color: AppTheme.neutral50,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        fullRecipe.strTags ?? 'Đơn giản nhưng ngon miệng',
                        style: TextStyle(
                          color: AppTheme.neutral200,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _scrollToInstructions(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.neutral50,
                          foregroundColor: AppTheme.primary900,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          'Chi tiết',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.neutral50),
            onPressed: () => Get.back(),
          ),
        ),

        // Food Menu Items - Using related recipes if available
        SliverToBoxAdapter(
          child: Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // We'll always show 5 cards
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary500,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(fullRecipe.strMealThumb ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.neutral950.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: AppTheme.neutral50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Recipe Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Title and Favorite
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        fullRecipe.strMeal ?? 'Recipe Title',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neutral950,
                        ),
                      ),
                    ),
                    Obx(() {
                      final isSaved = savedController.savedRecipes
                          .any((r) => r.idMeal == recipe.idMeal);
                      return IconButton(
                        icon: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            color: isSaved ? Colors.red : Colors.grey),
                        onPressed: () => savedController.toggleSave(recipe),
                      );
                    }),
                  ],
                ),

                // Recipe Category and Area
                Text(
                  "${fullRecipe.strCategory ?? ''} • ${fullRecipe.strArea ?? ''}",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.neutral700,
                  ),
                ),

                SizedBox(height: 16),

                // Rating and Reviews
                Row(
                  children: [
                    Icon(Icons.star, color: AppTheme.primary500, size: 18),
                    SizedBox(width: 4),
                    Text(
                      '4.2',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.neutral900,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '|',
                      style: TextStyle(
                        color: AppTheme.neutral500,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '120 đánh giá',
                      style: TextStyle(
                        color: AppTheme.neutral700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Author (using area as "author" since TheMealDB doesn't have author data)
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primary200,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://i.pravatar.cc/150?img=${fullRecipe.idMeal?.hashCode.remainder(10) ?? 3}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: AppTheme.primary700,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppTheme.neutral50, width: 2),
                              ),
                              child: Icon(Icons.favorite,
                                  color: AppTheme.neutral50, size: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      fullRecipe.strArea ?? 'Đầu bếp',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                Divider(height: 32, color: AppTheme.neutral300),

                // Tab Buttons
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => controller.changeTab(0),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  controller.selectedTabIndex.value == 0
                                      ? AppTheme.primary500
                                      : AppTheme.neutral200,
                              foregroundColor:
                                  controller.selectedTabIndex.value == 0
                                      ? AppTheme.neutral50
                                      : AppTheme.neutral700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Text('Nguyên liệu'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => controller.changeTab(1),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  controller.selectedTabIndex.value == 1
                                      ? AppTheme.primary500
                                      : AppTheme.neutral200,
                              foregroundColor:
                                  controller.selectedTabIndex.value == 1
                                      ? AppTheme.neutral50
                                      : AppTheme.neutral700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Text('Chế biến'),
                          ),
                        ),
                      ],
                    )),

                SizedBox(height: 24),

                // Content based on selected tab
                Obx(() => controller.selectedTabIndex.value == 0
                    ? _buildIngredientsTab(ingredients)
                    : _buildInstructionsTab(
                        fullRecipe.strInstructions ?? 'Không có hướng dẫn.')),

                SizedBox(height: 24),

                // Video Button - Make it functional with the YouTube link
                if (fullRecipe.strYoutube != null &&
                    fullRecipe.strYoutube!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _launchYoutubeVideo(fullRecipe.strYoutube!),
                      icon: Icon(Icons.play_circle_fill,
                          color: AppTheme.primary500),
                      label: Text('Xem video',
                          style: TextStyle(color: AppTheme.primary500)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary500,
                        side: BorderSide(color: AppTheme.primary500),
                        backgroundColor: AppTheme.primary100,
                      ),
                    ),
                  ),

                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Cập nhật để truyền vào Recipe object
  List<Map<String, String?>> _extractIngredientsAndMeasures(Recipe recipeData) {
    List<Map<String, String?>> result = [];

    // Loop through all possible ingredients from TheMealDB (up to 20)
    for (int i = 1; i <= 20; i++) {
      final Map<String, dynamic> recipeJson = recipeData.toJson();
      final ingredient = recipeJson['strIngredient$i'];
      final measure = recipeJson['strMeasure$i'];

      // Only add if ingredient exists and isn't empty
      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty &&
          ingredient.toString().trim() != 'null') {
        result.add({
          'ingredient': ingredient.toString().trim(),
          'measure': measure != null ? measure.toString().trim() : '',
        });
      }
    }

    return result;
  }

  // Build the ingredients tab content
  Widget _buildIngredientsTab(List<Map<String, String?>> ingredients) {
    if (ingredients.isEmpty) {
      return Center(
        child: Text(
          'Không có thông tin về nguyên liệu.',
          style: TextStyle(color: AppTheme.neutral700),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Serving Information
        Row(
          children: [
            Icon(Icons.people, color: AppTheme.primary500),
            SizedBox(width: 8),
            Text(
              'Dành cho 2-4 người ăn',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.neutral950,
              ),
            ),
          ],
        ),

        SizedBox(height: 16),

        // Main ingredients heading
        Text(
          'Nguyên liệu chính',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.neutral950,
          ),
        ),

        SizedBox(height: 12),

        // Main Ingredients (first half)
        ...ingredients.take(ingredients.length ~/ 2).map((item) {
          return _buildIngredientItem(
            item['ingredient'] ?? '',
            item['measure'] ?? '',
          );
        }).toList(),

        SizedBox(height: 24),

        // Spices/additional ingredients section
        if (ingredients.length > ingredients.length ~/ 2) ...[
          Text(
            'Gia vị & nguyên liệu phụ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.neutral950,
            ),
          ),

          SizedBox(height: 12),

          // Remaining ingredients (second half)
          ...ingredients.skip(ingredients.length ~/ 2).map((item) {
            return _buildIngredientItem(
              item['ingredient'] ?? '',
              item['measure'] ?? '',
            );
          }).toList(),
        ],
      ],
    );
  }

  // Build the instructions tab content
  Widget _buildInstructionsTab(String instructions) {
    // Split instructions by periods or paragraph breaks for better readability
    final steps = instructions
        .split(RegExp(r'(?<=[.!?])\s+|\n'))
        .where((step) => step.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hướng dẫn nấu ăn',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.neutral950,
          ),
        ),
        SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.primary500,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: AppTheme.neutral50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step.trim(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.neutral900,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildIngredientItem(String ingredient, String measure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Ingredient image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.primary100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                getIngredientImageUrl(ingredient),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.restaurant_menu,
                    color: AppTheme.primary500,
                    size: 24,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          // Ingredient text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neutral900,
                  ),
                ),
                if (measure.trim().isNotEmpty)
                  Text(
                    measure,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.neutral700,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Launch YouTube video
  void _launchYoutubeVideo(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'Lỗi',
        'Không thể mở video',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Scroll to instructions section
  void _scrollToInstructions(BuildContext context) {
    controller.changeTab(1);
  }

  String getIngredientImageUrl(String ingredient) {
    final formattedIngredient =
        ingredient.trim().toLowerCase().replaceAll(' ', '%20');

    return 'https://www.themealdb.com/images/ingredients/$formattedIngredient.png';
  }
}
