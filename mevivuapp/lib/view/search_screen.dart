import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/recipe_model.dart';
import '../controllers/search_controller.dart' as custom;
import '../widgets/custom_bottom_nav_bar.dart';

class SearchScreen extends StatelessWidget {
  final custom.SearchController controller = Get.put(custom.SearchController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, 
      body: SafeArea(
        bottom: false, 
        child: Column(
          children: [
           
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Obx(() => controller.isDetailView.value
                      ? IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: controller.backToList,
                        )
                      : SizedBox.shrink()),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: (value) => controller.searchRecipes(value),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showFilterModal(context),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.filter_list, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                      child: CircularProgressIndicator(color: Colors.amber));
                }

                // Check if we're in detail view mode
                if (controller.isDetailView.value &&
                    controller.selectedRecipe.value != null) {
                  return _buildRecipeDetail(controller.selectedRecipe.value!);
                }

                // Show suggestions when text is entered but no results are shown yet
                if (_searchController.text.isNotEmpty &&
                    controller.searchResults.isEmpty &&
                    controller.searchSuggestions.isNotEmpty) {
                  return _buildSuggestions();
                }

                // Show search results list
                return _buildSearchResults();
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.searchSuggestions.length,
      itemBuilder: (context, index) {
        final suggestion = controller.searchSuggestions[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.history, color: Colors.grey),
          title: Text(suggestion),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            _searchController.text = suggestion;
            controller.searchRecipes(suggestion);
          },
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (controller.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Show list of recipe names first (without images)
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final recipe = controller.searchResults[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          title: Text(
            recipe.strMeal ?? 'No Title',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${recipe.strCategory ?? ''} • ${recipe.strArea ?? ''}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: Icon(Icons.chevron_right),
          onTap: () => controller.selectRecipe(recipe),
        );
      },
    );
  }

  Widget _buildRecipeDetail(Recipe recipe) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe Image
          Stack(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                child: Image.network(
                  recipe.strMealThumb ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite_border, color: Colors.red),
                ),
              ),
            ],
          ),

          // Recipe Information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Category
                Text(
                  recipe.strMeal ?? 'No Title',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        recipe.strCategory ?? '',
                        style: TextStyle(
                          color: Colors.amber[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        recipe.strArea ?? '',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                Divider(height: 32),

                // Author Information
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=3'),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Little Pony',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '20 phút',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                Divider(height: 32),

                // Instructions
                Text(
                  'Hướng dẫn',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  recipe.strInstructions ?? 'No instructions available.',
                  style: TextStyle(
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 20),

                // Ingredients Section
                Text(
                  'Nguyên liệu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                _buildIngredientsList(recipe),

                SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsList(Recipe recipe) {
    // Extract ingredients from recipe object
    List<Map<String, String?>> ingredients = [];

    // The API has ingredients and measures spread across numbered fields
    for (int i = 1; i <= 20; i++) {
      final ingredient = recipe.toJson()['strIngredient$i'];
      final measure = recipe.toJson()['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add({
          'ingredient': ingredient,
          'measure': measure,
        });
      }
    }

    return Column(
      children: ingredients.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.restaurant, color: Colors.amber),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  '${item['ingredient']} - ${item['measure']}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Heart Icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  recipe.strMealThumb ?? '',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child:
                      Icon(Icons.favorite_border, color: Colors.red, size: 18),
                ),
              ),
            ],
          ),
          // Recipe Info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.strMeal ?? 'No Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'By Little Pony',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      '20m',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    // Make sure data is initialized
    controller.initializeFilterData();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Remove StatefulBuilder and just use Obx
        return Obx(() => Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lọc',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.resetFilters();
                            },
                            child: Text(
                              'Đặt lại',
                              style: TextStyle(color: Colors.amber),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(
                                context), // Use Navigator.pop instead of Get.back()
                          ),
                        ],
                      ),
                    ],
                  ),

                  Divider(),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Categories Section
                          Row(
                            children: [
                              Icon(Icons.category, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Danh mục',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.categories.isEmpty
                                ? [Text('Đang tải...')]
                                : controller.categories.map((category) {
                                    return _buildFilterChip(
                                        category,
                                        controller.selectedCategory.value ==
                                            category,
                                        (selected) => controller
                                            .selectedCategory
                                            .value = selected ? category : '');
                                  }).toList(),
                          ),

                          SizedBox(height: 20),

                          // Ingredients Section
                          Row(
                            children: [
                              Icon(Icons.restaurant_menu, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Nguyên liệu',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.ingredients.isEmpty
                                ? [Text('Đang tải...')]
                                : controller.ingredients
                                    .take(10)
                                    .map((ingredient) {
                                    return _buildFilterChip(
                                        ingredient,
                                        controller.selectedIngredient.value ==
                                            ingredient,
                                        (selected) => controller
                                                .selectedIngredient.value =
                                            selected ? ingredient : '');
                                  }).toList(),
                          ),

                          SizedBox(height: 20),

                          // Location Section
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Khu vực',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.areas.isEmpty
                                ? [Text('Đang tải...')]
                                : controller.areas.map((area) {
                                    return _buildFilterChip(
                                        area,
                                        controller.selectedArea.value == area,
                                        (selected) => controller.selectedArea
                                            .value = selected ? area : '');
                                  }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.filterRecipes();
                        Navigator.pop(
                            context); // Use Navigator.pop instead of Get.back()
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Xác nhận',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildFilterChip(
      String label, bool isSelected, Function(bool) onSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.amber,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}
