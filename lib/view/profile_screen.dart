import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mevivuapp/untils/app_theme.dart';
import 'package:mevivuapp/widgets/custom_bottom_nav_bar.dart';
import '../controllers/profile_controller.dart';
import '../controllers/saved_controller.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());
  final SavedController savedController = Get.find<SavedController>();
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    fetchAvatar();
  }

  Future<void> fetchAvatar() async {
    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        avatarUrl = data['meals'][0]['strMealThumb'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Avatar lấy từ API
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primary200,
                      backgroundImage:
                          avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                      child: avatarUrl == null
                          ? Text('NDT',
                              style: TextStyle(
                                  fontSize: 40, color: AppTheme.neutral950))
                          : null,
                    ),
                    SizedBox(height: 10),
                    Text(
                      controller.username.value,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neutral950),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Obx(() => Text(controller.posts.value.toString(),
                                style: TextStyle(color: AppTheme.neutral900))),
                            Text('Bài viết',
                                style: TextStyle(color: AppTheme.neutral700)),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Obx(() => Text(
                                controller.followers.value.toString(),
                                style: TextStyle(color: AppTheme.neutral900))),
                            Text('Người theo dõi',
                                style: TextStyle(color: AppTheme.neutral700)),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Obx(() => Text(
                                controller.following.value.toString(),
                                style: TextStyle(color: AppTheme.neutral900))),
                            Text('Đang theo dõi',
                                style: TextStyle(color: AppTheme.neutral700)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => controller.follow(),
                          child: Text('Follow'),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Message',
                              style: TextStyle(color: AppTheme.neutral900)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Danh sách yêu thích',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Obx(() => GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: savedController.savedRecipes.map((recipe) {
                      return Card(
                        child: GestureDetector(
                          onTap: () =>
                              Get.toNamed('/detail', arguments: recipe),
                          child: Image.network(
                            recipe.strMealThumb ??
                                'https://www.themealdb.com/images/media/meals/tytyvr1515353282.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }
}
