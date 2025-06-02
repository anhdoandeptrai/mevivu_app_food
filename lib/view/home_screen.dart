import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mevivuapp/models/recipe_model.dart';
import 'package:mevivuapp/untils/app_theme.dart';
import 'package:mevivuapp/widgets/custom_bottom_nav_bar.dart';
import '../controllers/home_controller.dart';
import '../controllers/saved_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final SavedController savedController = Get.find<SavedController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Obx(() => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () => Get.toNamed('/search'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                'Tìm kiếm sản phẩm',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Location Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TP. Hồ Chí Minh',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Xem tất cả',
                              style: TextStyle(
                                  color: Colors.amber[700], fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Featured Recipes
                    Container(
                      height: 360,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.featuredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = controller.featuredRecipes[index];
                          return _buildFeaturedCard(
                            imageUrl: recipe.strMealThumb ?? '',
                            title: recipe.strMeal ??
                                'Cách chiên trứng một cách cung phu',
                            duration: '1 tiếng 20 phút',
                            rating: 5,
                            authorName: 'Đinh Trọng Phúc',
                            recipe: recipe,
                          );
                        },
                      ),
                    ),

                    // Categories Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Danh mục',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Xem tất cả',
                              style: TextStyle(
                                  color: Colors.amber[700], fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Categories ListView (replacing the SingleChildScrollView with Row)
                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: 8, // Adjust based on your category count
                        itemBuilder: (context, index) {
                          // Simple logic to demonstrate selected state
                          bool isSelected = index == 0;
                          return _buildCategoryChip(
                              'Danh mục ${index + 1}', isSelected);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Horizontal Recipe List (replacing the Grid)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Công thức phổ biến',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Xem tất cả',
                                    style: TextStyle(
                                        color: Colors.amber[700], fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 220, // Set appropriate height
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              itemCount: controller.recipes.length,
                              itemBuilder: (context, index) {
                                return _buildGridRecipeCard(
                                    recipe: controller.recipes[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Recent Recipes Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: const Text(
                        'Công thức gần đây',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // Recent Recipes List
                    Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.recipes.take(3).length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final recipe = controller.recipes[index];
                          return _buildRecentRecipeCard(
                            recipe.strMealThumb ?? '',
                            'Trứng chiên',
                            'Nguyễn Đình Trọng',
                            recipe,
                          );
                        },
                      ),
                    ),

                    // Ingredients Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: const Text(
                        'Nguyên liệu',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // Ingredient Categories with smaller chips
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildCategoryChip('Danh mục 1', true,
                                  isSmall: true),
                              _buildCategoryChip('Danh mục 2', false,
                                  isSmall: true),
                              _buildCategoryChip('Danh mục', false,
                                  isSmall: true),
                              _buildCategoryChip('Danh mục 3', false,
                                  isSmall: true),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildCategoryChip('Danh mục 1', false,
                                  isSmall: true),
                              _buildCategoryChip('Danh mục 2', false,
                                  isSmall: true),
                              _buildCategoryChip('Danh mục', false,
                                  isSmall: true),
                              _buildCategoryChip('Danh mục 3', false,
                                  isSmall: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              )),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildFeaturedCard({
    required String imageUrl,
    required String title,
    required String duration,
    required int rating,
    required String authorName,
    required Recipe recipe,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed('/detail', arguments: recipe),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(left: 16, right: 8, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.red.withOpacity(0.2),
                              BlendMode.srcOver,
                            ),
                          ),
                          color: Colors.red[800],
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white.withOpacity(0.7),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  duration,
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Obx(() {
                                  final isSaved = savedController.savedRecipes
                                      .any((r) => r.idMeal == recipe.idMeal);
                                  return IconButton(
                                    icon: Icon(
                                        isSaved
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            isSaved ? Colors.red : Colors.grey),
                                    onPressed: () =>
                                        savedController.toggleSave(recipe),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                    "https://i.pravatar.cc/150?img=5",
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  authorName,
                                  style: TextStyle(color: AppTheme.primary600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$rating',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected,
      {bool isSmall = false}) {
    return Container(
      margin: EdgeInsets.only(right: isSmall ? 4 : 8),
      width: isSmall ? 90 : 110,
      child: ChoiceChip(
        showCheckmark: false,
        label: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        selected: isSelected,
        selectedColor: AppTheme.primary700,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: isSmall ? 12 : 14,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 8 : 12, vertical: isSmall ? 2 : 4),
        materialTapTargetSize: isSmall
            ? MaterialTapTargetSize.shrinkWrap
            : MaterialTapTargetSize.padded,
        labelPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildGridRecipeCard({required Recipe recipe}) {
    return GestureDetector(
      onTap: () => Get.toNamed('/detail', arguments: recipe),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5E8D4),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.fromLTRB(12, 45, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      recipe.strMeal ?? 'Trứng chiên',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF6B4E31),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tạo bởi\nTrần Đình Trọng',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B4E31),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${recipe.strDuration ?? '20 phút'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B4E31),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Color(0xFF6B4E31),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    recipe.strMealThumb ??
                        'https://www.themealdb.com/images/media/meals/wyxwsp1486979827.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRecipeCard(
      String imageUrl, String title, String author, Recipe recipe) {
    return GestureDetector(
      onTap: () => Get.toNamed('/detail', arguments: recipe),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?img=3'),
                ),
                const SizedBox(width: 8),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors
                        .blue, // Changed from Colors.grey[600] to Colors.blue
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
