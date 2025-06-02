import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mevivuapp/models/recipe_model.dart';
import 'package:mevivuapp/untils/app_theme.dart';
import 'package:mevivuapp/widgets/custom_bottom_nav_bar.dart';
import '../controllers/news_controller.dart';
import '../controllers/saved_controller.dart';

class NewsScreen extends StatelessWidget {
  final NewsController newsController = Get.put(NewsController());
  final SavedController savedController = Get.find<SavedController>();
  final RxInt selectedTab = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Công thức',
          style: TextStyle(
            color: AppTheme.primary700,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppTheme.primary500),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Tab Selector
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(() => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => selectedTab.value = 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selectedTab.value == 0
                                ? AppTheme.primary700
                                : Color(0xFFF7F1DE),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Video',
                            style: TextStyle(
                              color: selectedTab.value == 0
                                  ? Colors.white
                                  : AppTheme.primary700,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => selectedTab.value = 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selectedTab.value == 1
                                ? AppTheme.primary700
                                : Color(0xFFF7F1DE),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Công thức',
                            style: TextStyle(
                              color: selectedTab.value == 1
                                  ? Colors.white
                                  : AppTheme.primary700,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),

          // Recipe List
          Expanded(
            child: Obx(() {
              final recipes = newsController.newsRecipes;
              if (recipes.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              // Lọc danh sách theo tab
              final filtered = selectedTab.value == 0
                  ? recipes
                      .where((r) => (r.strYoutube ?? '').isNotEmpty)
                      .toList()
                  : recipes;
              if (filtered.isEmpty) {
                return Center(child: Text('Không có dữ liệu'));
              }
              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final recipe = filtered[index];
                  return _buildRecipeCard(recipe);
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe Image with Play Button and Rating
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  recipe.strMealThumb ?? '',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Play button overlay nếu có video
              if ((recipe.strYoutube ?? '').isNotEmpty)
                Positioned.fill(
                  child: Center(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.7),
                      child: Icon(
                        Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              // Rating badge
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary600,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Duration
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              '1 tiếng 20 phút',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Recipe Title and Favorite Button
          Row(
            children: [
              Expanded(
                child: Text(
                  recipe.strMeal ?? 'Cách chiên trứng một cách cung phu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Obx(() {
                final isSaved = savedController.savedRecipes
                    .any((r) => r.idMeal == recipe.idMeal);
                return IconButton(
                  icon: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => savedController.toggleSave(recipe),
                );
              }),
            ],
          ),

          // Author Info
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage:
                    NetworkImage('https://i.pravatar.cc/150?img=3'),
              ),
              SizedBox(width: 8),
              Row(
                children: [
                  Text(
                    'Đinh Trọng Phúc',
                    style: TextStyle(
                      color: AppTheme.primary600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
